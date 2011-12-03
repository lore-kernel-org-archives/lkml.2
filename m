Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1LCBL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:11:26 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55253 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab1LCBLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:11:25 -0500
X-Sasl-enc: xnO9iNbnLzF4g5AKKN7HpktEFuiUwKIPLs8oXa/XxfmH 1322874684
Date: Fri, 2 Dec 2011 17:11:18 -0800
From: Greg KH <greg@kroah.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, David Altobelli <david.altobelli@hp.com>,
        Brent Casavant <bcasavan@sgi.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] MISC: Convert to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20111203011118.GA5234@kroah.com>
References: <1322794977.25851.1.camel@phoenix>
 <20111202160326.GA13819@kroah.com>
 <CAF+7xWkO3j9eni_O2A-XbsQDPOQ23Xdc9meSMM3LA6Dac9DWWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF+7xWkO3j9eni_O2A-XbsQDPOQ23Xdc9meSMM3LA6Dac9DWWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 09:04:45AM +0800, Axel Lin wrote:
> 2011/12/3 Greg KH <greg@kroah.com>:
> > On Fri, Dec 02, 2011 at 11:02:57AM +0800, Axel Lin wrote:
> >> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> >> tables. Also convert to the PCI_DEVICE/PCI_VDEVICE macros for better
> >> readablity.
> >>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Greg Kroah-Hartman <greg@kroah.com>
> >> Cc: David Altobelli <david.altobelli@hp.com>
> >> Cc: Brent Casavant <bcasavan@sgi.com>
> >> Cc: Jiri Slaby <jirislaby@gmail.com>
> >> Cc: J Freyensee <james_p_freyensee@linux.intel.com>
> >> Cc: Alex Dubov <oakad@yahoo.com>
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >> ---
> >>  drivers/misc/hpilo.c     |    2 +-
> >>  drivers/misc/ioc4.c      |    6 +++---
> >>  drivers/misc/pch_phub.c  |    2 +-
> >>  drivers/misc/phantom.c   |    2 +-
> >>  drivers/misc/pti.c       |    2 +-
> >>  drivers/misc/tifm_7xx1.c |   11 ++++-------
> >>  6 files changed, 11 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
> >> index fffc227..f705cbb 100644
> >> --- a/drivers/misc/hpilo.c
> >> +++ b/drivers/misc/hpilo.c
> >> @@ -828,7 +828,7 @@ out:
> >>       return error;
> >>  }
> >>
> >> -static struct pci_device_id ilo_devices[] = {
> >> +static DEFINE_PCI_DEVICE_TABLE(ilo_devices) = {
> >
> > No, I hate this macro, see, it's actually taking you more characters to
> > use it than to just properly define the structure yourself.  It's
> > pointless and stupid.
> >
> $ grep -r "^static .*pci_device_id" drivers/misc/*
> drivers/misc/cb710/core.c:static const struct pci_device_id cb710_pci_tbl[] = {
> drivers/misc/hpilo.c:static struct pci_device_id ilo_devices[] = {
> drivers/misc/ibmasm/module.c:static int __devinit
> ibmasm_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
> drivers/misc/ibmasm/module.c:static struct pci_device_id ibmasm_pci_table[] =
> drivers/misc/ioc4.c:static struct pci_device_id ioc4_id_table[] = {
> drivers/misc/pch_phub.c:static struct pci_device_id pch_phub_pcidev_id[] = {
> drivers/misc/phantom.c:static struct pci_device_id phantom_pci_tbl[]
> __devinitdata = {
> drivers/misc/pti.c:static struct pci_device_id pci_ids[] __devinitconst = {
> drivers/misc/tifm_7xx1.c:static struct pci_device_id tifm_7xx1_pci_tbl [] = {
> 
> Some drivers missed const and __devinitconst annotations, it would be
> easier to use
> DEFINE_PCI_DEVICE_TABLE.

I still don't like it, sorry.

greg "stick in the mud" k-h
