Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab1DMVZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:25:30 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:61636 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab1DMVZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:25:27 -0400
X-MDAV-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 00:17:18 +0300
X-Spam-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 00:17:18 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=wzzzeF-PmqLt9o8arW7nRaFRRJw@mail.gmail.com>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
	 <20110413163113.GA24015@kroah.com>
	 <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
	 <1302726703.8015.1.camel@dev.znau.edu.ua>
	 <BANLkTimwZOJ0a5kVfaUzEcsMc39H999u0A@mail.gmail.com>
	 <1302727516.8015.9.camel@dev.znau.edu.ua>
	 <BANLkTi=wzzzeF-PmqLt9o8arW7nRaFRRJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 14 Apr 2011 00:14:03 +0300
Message-Id: <1302729243.8479.1.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2011/4/13 George Kashperko <george@znau.edu.ua>:
> >
> >> 2011/4/13 George Kashperko <george@znau.edu.ua>:
> >> >
> >> > В Срд, 13/04/2011 в 21:39 +0200, Rafał Miłecki пишет:
> >> >> 2011/4/13 Greg KH <greg@kroah.com>:
> >> >> >> diff --git a/drivers/axi/axi_pci_bridge.c b/drivers/axi/axi_pci_bridge.c
> >> >> >> new file mode 100644
> >> >> >> index 0000000..17e882c
> >> >> >> --- /dev/null
> >> >> >> +++ b/drivers/axi/axi_pci_bridge.c
> >> >> >> @@ -0,0 +1,33 @@
> >> >> >> +/*
> >> >> >> + * AXI PCI bridge module
> >> >> >> + *
> >> >> >> + * Licensed under the GNU/GPL. See COPYING for details.
> >> >> >> + */
> >> >> >> +
> >> >> >> +#include "axi_private.h"
> >> >> >> +
> >> >> >> +#include <linux/axi/axi.h>
> >> >> >> +#include <linux/pci.h>
> >> >> >> +
> >> >> >> +static DEFINE_PCI_DEVICE_TABLE(axi_pci_bridge_tbl) = {
> >> >> >> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
> >> >> >> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
> >> >> >> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
> >> >> >> +     { 0, },
> >> >> >> +};
> >> >> >> +MODULE_DEVICE_TABLE(pci, axi_pci_bridge_tbl);
> >> >> >> +
> >> >> >> +static struct pci_driver axi_pci_bridge_driver = {
> >> >> >> +     .name = "axi-pci-bridge",
> >> >> >> +     .id_table = axi_pci_bridge_tbl,
> >> >> >> +};
> >> >> >> +
> >> >> >> +int __init axi_pci_bridge_init(void)
> >> >> >> +{
> >> >> >> +     return axi_host_pci_register(&axi_pci_bridge_driver);
> >> >> >> +}
> >> >> >> +
> >> >> >> +void __exit axi_pci_bridge_exit(void)
> >> >> >> +{
> >> >> >> +     axi_host_pci_unregister(&axi_pci_bridge_driver);
> >> >> >> +}
> >> >> >
> >> >> > You register a pci driver that does nothing?  That's not right, you need
> >> >> > to then base your axi bus off of that pci device, so it is hooked up
> >> >> > correctly in the /sys/devices/ tree.  Otherwise you are somewhere up in
> >> >> > the virtual location for your axi bus, right?
> >> >>
> >> >> Please take a look at:
> >> >> driver->probe = axi_host_pci_probe;
> >> >> driver->remove = axi_host_pci_remove;
> >> >> return pci_register_driver(driver);
> >> >>
> >> >>
> >> >> >> +bool axi_core_is_enabled(struct axi_device *core)
> >> >> >> +{
> >> >> >> +     if ((axi_aread32(core, AXI_IOCTL) & (AXI_IOCTL_CLK | AXI_IOCTL_FGC))
> >> >> >> +         != AXI_IOCTL_CLK)
> >> >> >> +             return false;
> >> >> >> +     if (axi_aread32(core, AXI_RESET_CTL) & AXI_RESET_CTL_RESET)
> >> >> >> +             return false;
> >> >> >> +     return true;
> >> >> >> +}
> >> >> >> +EXPORT_SYMBOL(axi_core_is_enabled);
> >> >> >
> >> >> > EXPORT_SYMBOL_GPL()?
> >> >> >
> >> >> > What module uses this?  And why would it care?
> >> >> >
> >> >> >> +EXPORT_SYMBOL(axi_core_enable);
> >> >> >
> >> >> > EXPORT_SYMBOL_GPL()?
> >> >> >
> >> >> > Same goes for your other exports, just want you to be sure here.
> >> >>
> >> >> Hm, I'm not sure. Using EXPORT_SYMBOL_GPL will forbid closed source
> >> >> drivers from using our bus driver, right? I'm don't have preferences
> >> >> on this, if you prefer us to force GPL, I can.
> >> >>
> >> >>
> >> >> >> +u32 xaxi_chipco_gpio_control(struct axi_drv_cc *cc, u32 mask, u32 value)
> >> >> >> +{
> >> >> >> +     return axi_cc_write32_masked(cc, AXI_CC_GPIOCTL, mask, value);
> >> >> >> +}
> >> >> >> +EXPORT_SYMBOL(xaxi_chipco_gpio_control);
> >> >> >
> >> >> > "xaxi"?  Shouldn't that be consistant with the other exports and start
> >> >> > with "axi"?
> >> >>
> >> >> Left from old tests/rewrites/splitting. Thanks.
> >> >>
> >> >>
> >> >> >> +static u8 axi_host_pci_read8(struct axi_device *core, u16 offset)
> >> >> >> +{
> >> >> >> +     if (unlikely(core->bus->mapped_core != core))
> >> >> >
> >> >> > Are you sure about the use of unlikely in this, and other functions?
> >> >> > The compiler almost always does a better job than we do for these types
> >> >> > of calls, just let it do it's job.
> >> >> >
> >> >> >> +             axi_host_pci_switch_core(core);
> >> >> >> +     return ioread8(core->bus->mmio + offset);
> >> >> >
> >> >> > I think because of that unlikely, you just slowed down all pci devices,
> >> >> > right?  That's not very nice :)
> >> >>
> >> >> Hm, my logic suggests it is alright, but please consider this once
> >> >> more with me ;)
> >> >>
> >> >> For the most of the time mapped_core (active core) do not change. We
> >> >> perform few hundreds of operations on one core in a row. This way
> >> >> mapped_core points to passed core for most of the time. Condition
> >> >> (mapped_core != core) is unlikely to happen.
> >> >>
> >> >> Is there anything wrong in my logic?
> >> >>
> >> > Yes, there is. You don't need that "if" at all.
> >>
> >> Damn, WHY do you make me ask why, why, why, all the time?! Can't you
> >> just write word of explanation without being asked for?
> >>
> > Errm... Sorry, but I've already explained PCIE host behaviour _several_
> > times several days ago. Personally I like to ask questions. Have
> > absolutely nothing agains anyone else asking good questions. Never try
> > to make people ask me questions I know they would ask anyway. Really you
> > might missed some my messages earlier or maybe my english is too awful ?
> >
> > Yet again, for PCIE cores (not only for them, for some PCI cores as
> > well) buscommon, buscore and function core are all available
> > simultaneously. You dont need window sliding when access them.
> 
> I had no idea what you were referring to. We do not dig into PCIe
> functions yet, so I believe for now we need this "if".
You are already deep inside. Your host code drives pci function.

> 
> I'm getting totally frustrated with that whole situation :|
> 

Have nice day,
George


