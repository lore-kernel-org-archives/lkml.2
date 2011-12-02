Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1LBVBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:01:50 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49206 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755102Ab1LBVBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:01:49 -0500
Message-ID: <1322859708.17683.17.camel@joe2Laptop>
Subject: Re: [PATCH] MISC: Convert to DEFINE_PCI_DEVICE_TABLE
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        David Altobelli <david.altobelli@hp.com>,
        Brent Casavant <bcasavan@sgi.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Fri, 02 Dec 2011 13:01:48 -0800
In-Reply-To: <20111202160326.GA13819@kroah.com>
References: <1322794977.25851.1.camel@phoenix>
	 <20111202160326.GA13819@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 08:03 -0800, Greg KH wrote:
> On Fri, Dec 02, 2011 at 11:02:57AM +0800, Axel Lin wrote:
> > Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> > tables. Also convert to the PCI_DEVICE/PCI_VDEVICE macros for better
> > readablity.
[]
> > diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
[]
> > @@ -828,7 +828,7 @@ out:
> >  	return error;
> >  }
> >  
> > -static struct pci_device_id ilo_devices[] = {
> > +static DEFINE_PCI_DEVICE_TABLE(ilo_devices) = {
> 
> No, I hate this macro, see, it's actually taking you more characters to
> use it than to just properly define the structure yourself.  It's
> pointless and stupid.

Not quite.

include/linux/pci.h:#define DEFINE_PCI_DEVICE_TABLE(_table) \
include/linux/pci.h-	const struct pci_device_id _table[] __devinitconst

Using the macro does declare the struct const and
use attribute __devinitconst to place the table into
section .devinit.rodata.

The straight definition does not.

> So no, I'm not going to accept this patch, sorry.

Never in doubt, not always right...

cheers, Joe

