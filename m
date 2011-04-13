Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab1DMQbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:31:22 -0400
Received: from kroah.org ([198.145.64.141]:44739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab1DMQbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:31:19 -0400
Date: Wed, 13 Apr 2011 09:31:13 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
Message-ID: <20110413163113.GA24015@kroah.com>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 08:52:55PM +0200, Rafał Miłecki wrote:
> Cc: Greg KH <greg@kroah.com>
> Cc: Michael Büsch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: George Kashperko <george@znau.edu.ua>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andy Botting <andy@andybotting.com>
> Cc: linuxdriverproject <devel@linuxdriverproject.org>
> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> Greg: is this what you expected from dynamic allocation and documentation?
> 
> Did I miss any other comments about something to change?
> 
> V2: Rename to axi
>     Use DEFINE_PCI_DEVICE_TABLE in bridge
>     Make use of pr_fmt and pr_*
>     Store core class
>     Rename bridge to not b43 specific
>     Replace magic 0x1000 with BCMAI_CORE_SIZE
>     Remove some old "ssb" names and defines
>     Move BCMAI_ADDR_BASE def
>     Add drvdata field
> V3: Fix reloading (kfree issue)
>     Add 14e4:0x4331
>     Fix non-initialized struct issue
>     Drop useless inline functions wrappers for pci core drv
>     Proper pr_* usage
> V3.1: Include forgotten changes (pr_* and include related)
>     Explain why we dare to implement empty release function
> V4: Add ABI documentation
>     Move struct device to wrapper and alloc it dynamically
>     checkpatch.pl pointed fixes
> ---
>  Documentation/ABI/testing/sysfs-bus-axi   |   31 +++
>  drivers/Kconfig                           |    2 +
>  drivers/Makefile                          |    1 +
>  drivers/axi/Kconfig                       |   33 +++
>  drivers/axi/Makefile                      |    7 +
>  drivers/axi/TODO                          |    3 +
>  drivers/axi/axi_pci_bridge.c              |   33 +++
>  drivers/axi/axi_private.h                 |   37 +++
>  drivers/axi/core.c                        |   51 ++++
>  drivers/axi/driver_chipcommon.c           |   87 +++++++
>  drivers/axi/driver_chipcommon_pmu.c       |  134 ++++++++++
>  drivers/axi/driver_pci.c                  |  163 ++++++++++++
>  drivers/axi/host_pci.c                    |  178 +++++++++++++
>  drivers/axi/main.c                        |  271 ++++++++++++++++++++
>  drivers/axi/scan.c                        |  392 +++++++++++++++++++++++++++++
>  drivers/axi/scan.h                        |   56 ++++
>  include/linux/axi/axi.h                   |  227 +++++++++++++++++
>  include/linux/axi/axi_driver_chipcommon.h |  308 ++++++++++++++++++++++
>  include/linux/axi/axi_driver_pci.h        |   89 +++++++
>  include/linux/axi/axi_regs.h              |   34 +++
>  include/linux/mod_devicetable.h           |   17 ++
>  scripts/mod/file2alias.c                  |   21 ++
>  22 files changed, 2175 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-axi
>  create mode 100644 drivers/axi/Kconfig
>  create mode 100644 drivers/axi/Makefile
>  create mode 100644 drivers/axi/TODO
>  create mode 100644 drivers/axi/axi_pci_bridge.c
>  create mode 100644 drivers/axi/axi_private.h
>  create mode 100644 drivers/axi/core.c
>  create mode 100644 drivers/axi/driver_chipcommon.c
>  create mode 100644 drivers/axi/driver_chipcommon_pmu.c
>  create mode 100644 drivers/axi/driver_pci.c
>  create mode 100644 drivers/axi/host_pci.c
>  create mode 100644 drivers/axi/main.c
>  create mode 100644 drivers/axi/scan.c
>  create mode 100644 drivers/axi/scan.h
>  create mode 100644 include/linux/axi/axi.h
>  create mode 100644 include/linux/axi/axi_driver_chipcommon.h
>  create mode 100644 include/linux/axi/axi_driver_pci.h
>  create mode 100644 include/linux/axi/axi_regs.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-axi b/Documentation/ABI/testing/sysfs-bus-axi
> new file mode 100644
> index 0000000..6223612
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-axi
> @@ -0,0 +1,31 @@
> +What:		/sys/bus/axi/devices/.../class
> +Date:		April 2011
> +KernelVersion:	2.6.40
> +Contact:	Rafał Miłecki <zajec5@gmail.com>
> +Description:
> +		Each AXI core is identified by few fields, including class it
> +		belongs to. See include/linux/axi/axi.h for possible values.
> +
> +What:		/sys/bus/axi/devices/.../manuf
> +Date:		April 2011
> +KernelVersion:	2.6.40
> +Contact:	Rafał Miłecki <zajec5@gmail.com>
> +Description:
> +		Each AXI core has it's manufacturer id. See
> +		include/linux/axi/axi.h for possible values.
> +
> +What:		/sys/bus/axi/devices/.../rev
> +Date:		April 2011
> +KernelVersion:	2.6.40
> +Contact:	Rafał Miłecki <zajec5@gmail.com>
> +Description:
> +		AXI cores of the same type can still slightly differ depending
> +		on their revision. Use it for detailed programming.
> +
> +What:		/sys/bus/axi/devices/.../id
> +Date:		April 2011
> +KernelVersion:	2.6.40
> +Contact:	Rafał Miłecki <zajec5@gmail.com>
> +Description:
> +		There are a few types of AXI cores, they can be identified by
> +		id field.
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 177c7d1..1244e8c 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -68,6 +68,8 @@ source "drivers/watchdog/Kconfig"
>  
>  source "drivers/ssb/Kconfig"
>  
> +source "drivers/axi/Kconfig"
> +
>  source "drivers/mfd/Kconfig"
>  
>  source "drivers/regulator/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 3f135b6..6e1979b 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -110,6 +110,7 @@ obj-$(CONFIG_HID)		+= hid/
>  obj-$(CONFIG_PPC_PS3)		+= ps3/
>  obj-$(CONFIG_OF)		+= of/
>  obj-$(CONFIG_SSB)		+= ssb/
> +obj-$(CONFIG_AXI)		+= axi/
>  obj-$(CONFIG_VHOST_NET)		+= vhost/
>  obj-$(CONFIG_VLYNQ)		+= vlynq/
>  obj-$(CONFIG_STAGING)		+= staging/
> diff --git a/drivers/axi/Kconfig b/drivers/axi/Kconfig
> new file mode 100644
> index 0000000..6221af0
> --- /dev/null
> +++ b/drivers/axi/Kconfig
> @@ -0,0 +1,33 @@
> +config AXI_POSSIBLE
> +	bool
> +	depends on HAS_IOMEM && HAS_DMA
> +	default y
> +
> +menu "AMBA AXI"
> +	depends on AXI_POSSIBLE
> +
> +config AXI
> +	tristate "AXI support"
> +	depends on AXI_POSSIBLE
> +	help
> +	  Bus driver for one of the Advanced Microcontroller Bus Architecture
> +	  interfaces: Advanced eXtensible Interface.
> +
> +config AXI_HOST_PCI_POSSIBLE
> +	bool
> +	depends on AXI && PCI = y
> +	default y
> +
> +config AXI_HOST_PCI
> +	bool "Support for AXI on PCI-host bus"
> +	depends on AXI_HOST_PCI_POSSIBLE
> +
> +config AXI_DEBUG
> +	bool "AXI debugging"
> +	depends on AXI
> +	help
> +	  This turns on additional debugging messages.
> +
> +	  If unsure, say N
> +
> +endmenu
> diff --git a/drivers/axi/Makefile b/drivers/axi/Makefile
> new file mode 100644
> index 0000000..50d6797
> --- /dev/null
> +++ b/drivers/axi/Makefile
> @@ -0,0 +1,7 @@
> +axi-y					+= main.o scan.o core.o
> +axi-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
> +axi-y					+= driver_pci.o
> +axi-$(CONFIG_AXI_HOST_PCI)		+= host_pci.o axi_pci_bridge.o
> +obj-$(CONFIG_AXI)			+= axi.o
> +
> +ccflags-$(CONFIG_AXI_DEBUG)		:= -DDEBUG
> diff --git a/drivers/axi/TODO b/drivers/axi/TODO
> new file mode 100644
> index 0000000..5190336
> --- /dev/null
> +++ b/drivers/axi/TODO
> @@ -0,0 +1,3 @@
> +- Interrupts
> +- Defines for PCI core driver
> +- Convert axi_bus->cores into linked list
> diff --git a/drivers/axi/axi_pci_bridge.c b/drivers/axi/axi_pci_bridge.c
> new file mode 100644
> index 0000000..17e882c
> --- /dev/null
> +++ b/drivers/axi/axi_pci_bridge.c
> @@ -0,0 +1,33 @@
> +/*
> + * AXI PCI bridge module
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "axi_private.h"
> +
> +#include <linux/axi/axi.h>
> +#include <linux/pci.h>
> +
> +static DEFINE_PCI_DEVICE_TABLE(axi_pci_bridge_tbl) = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
> +	{ 0, },
> +};
> +MODULE_DEVICE_TABLE(pci, axi_pci_bridge_tbl);
> +
> +static struct pci_driver axi_pci_bridge_driver = {
> +	.name = "axi-pci-bridge",
> +	.id_table = axi_pci_bridge_tbl,
> +};
> +
> +int __init axi_pci_bridge_init(void)
> +{
> +	return axi_host_pci_register(&axi_pci_bridge_driver);
> +}
> +
> +void __exit axi_pci_bridge_exit(void)
> +{
> +	axi_host_pci_unregister(&axi_pci_bridge_driver);
> +}

You register a pci driver that does nothing?  That's not right, you need
to then base your axi bus off of that pci device, so it is hooked up
correctly in the /sys/devices/ tree.  Otherwise you are somewhere up in
the virtual location for your axi bus, right?

> +bool axi_core_is_enabled(struct axi_device *core)
> +{
> +	if ((axi_aread32(core, AXI_IOCTL) & (AXI_IOCTL_CLK | AXI_IOCTL_FGC))
> +	    != AXI_IOCTL_CLK)
> +		return false;
> +	if (axi_aread32(core, AXI_RESET_CTL) & AXI_RESET_CTL_RESET)
> +		return false;
> +	return true;
> +}
> +EXPORT_SYMBOL(axi_core_is_enabled);

EXPORT_SYMBOL_GPL()?

What module uses this?  And why would it care?

> +EXPORT_SYMBOL(axi_core_enable);

EXPORT_SYMBOL_GPL()?

Same goes for your other exports, just want you to be sure here.

> +u32 xaxi_chipco_gpio_control(struct axi_drv_cc *cc, u32 mask, u32 value)
> +{
> +	return axi_cc_write32_masked(cc, AXI_CC_GPIOCTL, mask, value);
> +}
> +EXPORT_SYMBOL(xaxi_chipco_gpio_control);

"xaxi"?  Shouldn't that be consistant with the other exports and start
with "axi"?

> +static u8 axi_host_pci_read8(struct axi_device *core, u16 offset)
> +{
> +	if (unlikely(core->bus->mapped_core != core))

Are you sure about the use of unlikely in this, and other functions?
The compiler almost always does a better job than we do for these types
of calls, just let it do it's job.

> +		axi_host_pci_switch_core(core);
> +	return ioread8(core->bus->mmio + offset);

I think because of that unlikely, you just slowed down all pci devices,
right?  That's not very nice :)


thanks,

greg k-h
