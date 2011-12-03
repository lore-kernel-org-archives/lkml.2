Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1LCBFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:05:11 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34669 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab1LCBFJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:05:09 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111202160326.GA13819@kroah.com>
References: <1322794977.25851.1.camel@phoenix> <20111202160326.GA13819@kroah.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sat, 3 Dec 2011 09:04:45 +0800
Message-ID: <CAF+7xWkO3j9eni_O2A-XbsQDPOQ23Xdc9meSMM3LA6Dac9DWWw@mail.gmail.com>
Subject: Re: [PATCH] MISC: Convert to DEFINE_PCI_DEVICE_TABLE
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, David Altobelli <david.altobelli@hp.com>,
        Brent Casavant <bcasavan@sgi.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/3 Greg KH <greg@kroah.com>:
> On Fri, Dec 02, 2011 at 11:02:57AM +0800, Axel Lin wrote:
>> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
>> tables. Also convert to the PCI_DEVICE/PCI_VDEVICE macros for better
>> readablity.
>>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Greg Kroah-Hartman <greg@kroah.com>
>> Cc: David Altobelli <david.altobelli@hp.com>
>> Cc: Brent Casavant <bcasavan@sgi.com>
>> Cc: Jiri Slaby <jirislaby@gmail.com>
>> Cc: J Freyensee <james_p_freyensee@linux.intel.com>
>> Cc: Alex Dubov <oakad@yahoo.com>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/misc/hpilo.c     |    2 +-
>>  drivers/misc/ioc4.c      |    6 +++---
>>  drivers/misc/pch_phub.c  |    2 +-
>>  drivers/misc/phantom.c   |    2 +-
>>  drivers/misc/pti.c       |    2 +-
>>  drivers/misc/tifm_7xx1.c |   11 ++++-------
>>  6 files changed, 11 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
>> index fffc227..f705cbb 100644
>> --- a/drivers/misc/hpilo.c
>> +++ b/drivers/misc/hpilo.c
>> @@ -828,7 +828,7 @@ out:
>>       return error;
>>  }
>>
>> -static struct pci_device_id ilo_devices[] = {
>> +static DEFINE_PCI_DEVICE_TABLE(ilo_devices) = {
>
> No, I hate this macro, see, it's actually taking you more characters to
> use it than to just properly define the structure yourself.  It's
> pointless and stupid.
>
$ grep -r "^static .*pci_device_id" drivers/misc/*
drivers/misc/cb710/core.c:static const struct pci_device_id cb710_pci_tbl[] = {
drivers/misc/hpilo.c:static struct pci_device_id ilo_devices[] = {
drivers/misc/ibmasm/module.c:static int __devinit
ibmasm_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
drivers/misc/ibmasm/module.c:static struct pci_device_id ibmasm_pci_table[] =
drivers/misc/ioc4.c:static struct pci_device_id ioc4_id_table[] = {
drivers/misc/pch_phub.c:static struct pci_device_id pch_phub_pcidev_id[] = {
drivers/misc/phantom.c:static struct pci_device_id phantom_pci_tbl[]
__devinitdata = {
drivers/misc/pti.c:static struct pci_device_id pci_ids[] __devinitconst = {
drivers/misc/tifm_7xx1.c:static struct pci_device_id tifm_7xx1_pci_tbl [] = {

Some drivers missed const and __devinitconst annotations, it would be
easier to use
DEFINE_PCI_DEVICE_TABLE.
