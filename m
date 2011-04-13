Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab1DMSZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:25:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41693 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab1DMSZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YxNshGKwHOzHFOWsLhR0HK5D+FkVAfzzfjU6NEwA/Ns2PieGClMbhjhmoJWfC+gE1B
         Hs0YxIWwpkBVmikW8sQrhPCp82c/RYTr+sbwSu+5Ui8G7eb+FcsKkeyAIsotB5+PDC9M
         UH8T8ser5ohy6loQAL8cswWpLW2mAygQIx9aQ=
Message-ID: <4DA5EA73.2040803@lwfinger.net>
Date: Wed, 13 Apr 2011 13:24:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?B?TWljaGFl?= =?UTF-8?B?bCBCw7xzY2g=?= <mb@bu3sch.de>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 01:52 PM, Rafał Miłecki wrote:
> Cc: Greg KH<greg@kroah.com>
> Cc: Michael Büsch<mb@bu3sch.de>
> Cc: Larry Finger<Larry.Finger@lwfinger.net>
> Cc: George Kashperko<george@znau.edu.ua>
> Cc: Arend van Spriel<arend@broadcom.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Russell King<rmk@arm.linux.org.uk>
> Cc: Arnd Bergmann<arnd@arndb.de>
> Cc: Andy Botting<andy@andybotting.com>
> Cc: linuxdriverproject<devel@linuxdriverproject.org>
> Cc: linux-kernel@vger.kernel.org<linux-kernel@vger.kernel.org>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> Greg: is this what you expected from dynamic allocation and documentation?
>
> Did I miss any other comments about something to change?
>
> V2: Rename to axi
>      Use DEFINE_PCI_DEVICE_TABLE in bridge
>      Make use of pr_fmt and pr_*
>      Store core class
>      Rename bridge to not b43 specific
>      Replace magic 0x1000 with BCMAI_CORE_SIZE
>      Remove some old "ssb" names and defines
>      Move BCMAI_ADDR_BASE def
>      Add drvdata field
> V3: Fix reloading (kfree issue)
>      Add 14e4:0x4331
>      Fix non-initialized struct issue
>      Drop useless inline functions wrappers for pci core drv
>      Proper pr_* usage
> V3.1: Include forgotten changes (pr_* and include related)
>      Explain why we dare to implement empty release function
> V4: Add ABI documentation
>      Move struct device to wrapper and alloc it dynamically
>      checkpatch.pl pointed fixes
> ---
>   Documentation/ABI/testing/sysfs-bus-axi   |   31 +++
>   drivers/Kconfig                           |    2 +
>   drivers/Makefile                          |    1 +
>   drivers/axi/Kconfig                       |   33 +++
>   drivers/axi/Makefile                      |    7 +
>   drivers/axi/TODO                          |    3 +
>   drivers/axi/axi_pci_bridge.c              |   33 +++
>   drivers/axi/axi_private.h                 |   37 +++
>   drivers/axi/core.c                        |   51 ++++
>   drivers/axi/driver_chipcommon.c           |   87 +++++++
>   drivers/axi/driver_chipcommon_pmu.c       |  134 ++++++++++
>   drivers/axi/driver_pci.c                  |  163 ++++++++++++
>   drivers/axi/host_pci.c                    |  178 +++++++++++++
>   drivers/axi/main.c                        |  271 ++++++++++++++++++++
>   drivers/axi/scan.c                        |  392 +++++++++++++++++++++++++++++
>   drivers/axi/scan.h                        |   56 ++++
>   include/linux/axi/axi.h                   |  227 +++++++++++++++++
>   include/linux/axi/axi_driver_chipcommon.h |  308 ++++++++++++++++++++++
>   include/linux/axi/axi_driver_pci.h        |   89 +++++++
>   include/linux/axi/axi_regs.h              |   34 +++
>   include/linux/mod_devicetable.h           |   17 ++
>   scripts/mod/file2alias.c                  |   21 ++
>   22 files changed, 2175 insertions(+), 0 deletions(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-bus-axi
>   create mode 100644 drivers/axi/Kconfig
>   create mode 100644 drivers/axi/Makefile
>   create mode 100644 drivers/axi/TODO
>   create mode 100644 drivers/axi/axi_pci_bridge.c
>   create mode 100644 drivers/axi/axi_private.h
>   create mode 100644 drivers/axi/core.c
>   create mode 100644 drivers/axi/driver_chipcommon.c
>   create mode 100644 drivers/axi/driver_chipcommon_pmu.c
>   create mode 100644 drivers/axi/driver_pci.c
>   create mode 100644 drivers/axi/host_pci.c
>   create mode 100644 drivers/axi/main.c
>   create mode 100644 drivers/axi/scan.c
>   create mode 100644 drivers/axi/scan.h
>   create mode 100644 include/linux/axi/axi.h
>   create mode 100644 include/linux/axi/axi_driver_chipcommon.h
>   create mode 100644 include/linux/axi/axi_driver_pci.h
>   create mode 100644 include/linux/axi/axi_regs.h
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
> +Contact:	Rafał Miłecki<zajec5@gmail.com>
> +Description:
> +		Each AXI core is identified by few fields, including class it
> +		belongs to. See include/linux/axi/axi.h for possible values.
> +
> +What:		/sys/bus/axi/devices/.../manuf
> +Date:		April 2011
> +KernelVersion:	2.6.40
> +Contact:	Rafał Miłecki<zajec5@gmail.com>
> +Description:
> +		Each AXI core has it's manufacturer id. See
> +		include/linux/axi/axi.h for possible values.
> +
> +What:		/sys/bus/axi/devices/.../rev
> +Date:		April 2011
> +KernelVersion:	2.6.40
> +Contact:	Rafał Miłecki<zajec5@gmail.com>
> +Description:
> +		AXI cores of the same type can still slightly differ depending
> +		on their revision. Use it for detailed programming.
> +
> +What:		/sys/bus/axi/devices/.../id
> +Date:		April 2011
> +KernelVersion:	2.6.40
> +Contact:	Rafał Miłecki<zajec5@gmail.com>
> +Description:
> +		There are a few types of AXI cores, they can be identified by
> +		id field.
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 177c7d1..1244e8c 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -68,6 +68,8 @@ source "drivers/watchdog/Kconfig"
>
>   source "drivers/ssb/Kconfig"
>
> +source "drivers/axi/Kconfig"
> +
>   source "drivers/mfd/Kconfig"
>
>   source "drivers/regulator/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 3f135b6..6e1979b 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -110,6 +110,7 @@ obj-$(CONFIG_HID)		+= hid/
>   obj-$(CONFIG_PPC_PS3)		+= ps3/
>   obj-$(CONFIG_OF)		+= of/
>   obj-$(CONFIG_SSB)		+= ssb/
> +obj-$(CONFIG_AXI)		+= axi/
>   obj-$(CONFIG_VHOST_NET)		+= vhost/
>   obj-$(CONFIG_VLYNQ)		+= vlynq/
>   obj-$(CONFIG_STAGING)		+= staging/
> diff --git a/drivers/axi/Kconfig b/drivers/axi/Kconfig
> new file mode 100644
> index 0000000..6221af0
> --- /dev/null
> +++ b/drivers/axi/Kconfig
> @@ -0,0 +1,33 @@
> +config AXI_POSSIBLE
> +	bool
> +	depends on HAS_IOMEM&&  HAS_DMA
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
> +	depends on AXI&&  PCI = y
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
> +#include<linux/axi/axi.h>
> +#include<linux/pci.h>
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
> diff --git a/drivers/axi/axi_private.h b/drivers/axi/axi_private.h
> new file mode 100644
> index 0000000..756efb6
> --- /dev/null
> +++ b/drivers/axi/axi_private.h
> @@ -0,0 +1,37 @@
> +#ifndef LINUX_AXI_PRIVATE_H_
> +#define LINUX_AXI_PRIVATE_H_
> +
> +#ifndef pr_fmt
> +#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
> +#endif
> +
> +#include<linux/axi/axi.h>
> +
> +#define AXI_ADDR_BASE		0x18000000
> +#define AXI_WRAP_BASE		0x18100000
> +
> +#define AXI_CORE_SIZE		0x1000
> +
> +struct axi_bus;
> +
> +/* main.c */
> +extern int axi_bus_register(struct axi_bus *bus);
> +extern void axi_bus_unregister(struct axi_bus *bus);
> +
> +/* scan.c */
> +int axi_bus_scan(struct axi_bus *bus);
> +
> +#ifdef CONFIG_AXI_HOST_PCI
> +/* b43_pci_ai_bridge.c */
> +extern int __init axi_pci_bridge_init(void);
> +extern void __exit axi_pci_bridge_exit(void);
> +
> +/* host_pci.c */
> +extern int axi_host_pci_register(struct pci_driver *driver);
> +static inline void axi_host_pci_unregister(struct pci_driver *driver)
> +{
> +	pci_unregister_driver(driver);
> +}
> +#endif /* CONFIG_AXI_HOST_PCI */
> +
> +#endif
> diff --git a/drivers/axi/core.c b/drivers/axi/core.c
> new file mode 100644
> index 0000000..3d79749
> --- /dev/null
> +++ b/drivers/axi/core.c
> @@ -0,0 +1,51 @@
> +/*
> + * AMBA AXI
> + * Core ops
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "axi_private.h"
> +#include<linux/axi/axi.h>

#include <linux/delay.h>

> +
> +bool axi_core_is_enabled(struct axi_device *core)
> +{
> +	if ((axi_aread32(core, AXI_IOCTL)&  (AXI_IOCTL_CLK | AXI_IOCTL_FGC))
> +	    != AXI_IOCTL_CLK)
> +		return false;
> +	if (axi_aread32(core, AXI_RESET_CTL)&  AXI_RESET_CTL_RESET)
> +		return false;
> +	return true;
> +}
> +EXPORT_SYMBOL(axi_core_is_enabled);
> +
> +static void axi_core_disable(struct axi_device *core, u32 flags)
> +{
> +	if (axi_aread32(core, AXI_RESET_CTL)&  AXI_RESET_CTL_RESET)
> +		return;
> +
> +	axi_awrite32(core, AXI_IOCTL, flags);
> +	axi_aread32(core, AXI_IOCTL);
> +	udelay(10);
> +
> +	axi_awrite32(core, AXI_RESET_CTL, AXI_RESET_CTL_RESET);
> +	udelay(1);
> +}
> +
> +int axi_core_enable(struct axi_device *core, u32 flags)
> +{
> +	axi_core_disable(core, flags);
> +
> +	axi_awrite32(core, AXI_IOCTL, (AXI_IOCTL_CLK | AXI_IOCTL_FGC | flags));
> +	axi_aread32(core, AXI_IOCTL);
> +
> +	axi_awrite32(core, AXI_RESET_CTL, 0);
> +	udelay(1);
> +
> +	axi_awrite32(core, AXI_IOCTL, (AXI_IOCTL_CLK | flags));
> +	axi_aread32(core, AXI_IOCTL);
> +	udelay(1);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(axi_core_enable);
> diff --git a/drivers/axi/driver_chipcommon.c b/drivers/axi/driver_chipcommon.c
> new file mode 100644
> index 0000000..b3087df
> --- /dev/null
> +++ b/drivers/axi/driver_chipcommon.c
> @@ -0,0 +1,87 @@
> +/*
> + * AMBA AXI
> + * ChipCommon core driver
> + *
> + * Copyright 2005, Broadcom Corporation
> + * Copyright 2006, 2007, Michael Buesch<mb@bu3sch.de>
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "axi_private.h"
> +#include<linux/axi/axi.h>
> +
> +static inline u32 axi_cc_write32_masked(struct axi_drv_cc *cc, u16 offset,
> +					u32 mask, u32 value)
> +{
> +	value&= mask;
> +	value |= axi_cc_read32(cc, offset)&  ~mask;
> +	axi_cc_write32(cc, offset, value);
> +
> +	return value;
> +}
> +
> +void axi_core_chipcommon_init(struct axi_drv_cc *cc)
> +{
> +	if (cc->core->id.rev>= 11)
> +		cc->status = axi_cc_read32(cc, AXI_CC_CHIPSTAT);
> +	cc->capabilities = axi_cc_read32(cc, AXI_CC_CAP);
> +	if (cc->core->id.rev>= 35)
> +		cc->capabilities_ext = axi_cc_read32(cc, AXI_CC_CAP_EXT);
> +
> +	axi_cc_write32(cc, 0x58, 0);
> +	axi_cc_write32(cc, 0x5C, 0);
> +
> +	if (cc->capabilities&  AXI_CC_CAP_PMU)
> +		axi_pmu_init(cc);
> +	if (cc->capabilities&  AXI_CC_CAP_PCTL)
> +		pr_err("Power control not implemented!\n");
> +}
> +
> +/* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
> +void axi_chipco_watchdog_timer_set(struct axi_drv_cc *cc, u32 ticks)
> +{
> +	/* instant NMI */
> +	axi_cc_write32(cc, AXI_CC_WATCHDOG, ticks);
> +}
> +
> +void axi_chipco_irq_mask(struct axi_drv_cc *cc, u32 mask, u32 value)
> +{
> +	axi_cc_write32_masked(cc, AXI_CC_IRQMASK, mask, value);
> +}
> +
> +u32 axi_chipco_irq_status(struct axi_drv_cc *cc, u32 mask)
> +{
> +	return axi_cc_read32(cc, AXI_CC_IRQSTAT)&  mask;
> +}
> +
> +u32 axi_chipco_gpio_in(struct axi_drv_cc *cc, u32 mask)
> +{
> +	return axi_cc_read32(cc, AXI_CC_GPIOIN)&  mask;
> +}
> +
> +u32 axi_chipco_gpio_out(struct axi_drv_cc *cc, u32 mask, u32 value)
> +{
> +	return axi_cc_write32_masked(cc, AXI_CC_GPIOOUT, mask, value);
> +}
> +
> +u32 axi_chipco_gpio_outen(struct axi_drv_cc *cc, u32 mask, u32 value)
> +{
> +	return axi_cc_write32_masked(cc, AXI_CC_GPIOOUTEN, mask, value);
> +}
> +
> +u32 xaxi_chipco_gpio_control(struct axi_drv_cc *cc, u32 mask, u32 value)
> +{
> +	return axi_cc_write32_masked(cc, AXI_CC_GPIOCTL, mask, value);
> +}
> +EXPORT_SYMBOL(xaxi_chipco_gpio_control);
> +
> +u32 axi_chipco_gpio_intmask(struct axi_drv_cc *cc, u32 mask, u32 value)
> +{
> +	return axi_cc_write32_masked(cc, AXI_CC_GPIOIRQ, mask, value);
> +}
> +
> +u32 axi_chipco_gpio_polarity(struct axi_drv_cc *cc, u32 mask, u32 value)
> +{
> +	return axi_cc_write32_masked(cc, AXI_CC_GPIOPOL, mask, value);
> +}
> diff --git a/drivers/axi/driver_chipcommon_pmu.c b/drivers/axi/driver_chipcommon_pmu.c
> new file mode 100644
> index 0000000..b57a9d0
> --- /dev/null
> +++ b/drivers/axi/driver_chipcommon_pmu.c
> @@ -0,0 +1,134 @@
> +/*
> + * AMBA AXI
> + * ChipCommon Power Management Unit driver
> + *
> + * Copyright 2009, Michael Buesch<mb@bu3sch.de>
> + * Copyright 2007, Broadcom Corporation
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "axi_private.h"
> +#include<linux/axi/axi.h>
> +
> +static void axi_chipco_chipctl_maskset(struct axi_drv_cc *cc,
> +					 u32 offset, u32 mask, u32 set)
> +{
> +	u32 value;
> +
> +	axi_cc_read32(cc, AXI_CC_CHIPCTL_ADDR);
> +	axi_cc_write32(cc, AXI_CC_CHIPCTL_ADDR, offset);
> +	axi_cc_read32(cc, AXI_CC_CHIPCTL_ADDR);
> +	value = axi_cc_read32(cc, AXI_CC_CHIPCTL_DATA);
> +	value&= mask;
> +	value |= set;
> +	axi_cc_write32(cc, AXI_CC_CHIPCTL_DATA, value);
> +	axi_cc_read32(cc, AXI_CC_CHIPCTL_DATA);
> +}
> +
> +static void axi_pmu_pll_init(struct axi_drv_cc *cc)
> +{
> +	struct axi_bus *bus = cc->core->bus;
> +
> +	switch (bus->chipinfo.id) {
> +	case 0x4313:
> +	case 0x4331:
> +	case 43224:
> +	case 43225:
> +		break;
> +	default:
> +		pr_err("PLL init unknown for device 0x%04X\n",
> +			bus->chipinfo.id);
> +	}
> +}
> +
> +static void axi_pmu_resources_init(struct axi_drv_cc *cc)
> +{
> +	struct axi_bus *bus = cc->core->bus;
> +	u32 min_msk = 0, max_msk = 0;
> +
> +	switch (bus->chipinfo.id) {
> +	case 0x4313:
> +		min_msk = 0x200D;
> +		max_msk = 0xFFFF;
> +		break;
> +	case 43224:
> +		break;
> +	default:
> +		pr_err("PMU resource config unknown for device 0x%04X\n",
> +			bus->chipinfo.id);
> +	}
> +
> +	/* Set the resource masks. */
> +	if (min_msk)
> +		axi_cc_write32(cc, AXI_CC_PMU_MINRES_MSK, min_msk);
> +	if (max_msk)
> +		axi_cc_write32(cc, AXI_CC_PMU_MAXRES_MSK, max_msk);
> +}
> +
> +void axi_pmu_swreg_init(struct axi_drv_cc *cc)
> +{
> +	struct axi_bus *bus = cc->core->bus;
> +
> +	switch (bus->chipinfo.id) {
> +	case 0x4313:
> +	case 0x4331:
> +	case 43224:
> +		break;
> +	default:
> +		pr_err("PMU switch/regulators init unknown for device "
> +			"0x%04X\n", bus->chipinfo.id);
> +	}
> +}
> +
> +void axi_pmu_workarounds(struct axi_drv_cc *cc)
> +{
> +	struct axi_bus *bus = cc->core->bus;
> +
> +	switch (bus->chipinfo.id) {
> +	case 0x4313:
> +		axi_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
> +		break;
> +	case 0x4331:
> +		pr_err("Enabling Ext PA lines not implemented\n");
> +		break;
> +	case 43224:
> +		if (bus->chipinfo.rev == 0) {
> +			pr_err("Workarounds for 43224 rev 0 not fully "
> +				"implemented\n");
> +			axi_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
> +		} else {
> +			axi_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
> +		}
> +		break;
> +	default:
> +		pr_err("Workarounds unknown for device 0x%04X\n",
> +			bus->chipinfo.id);
> +	}
> +}
> +
> +void axi_pmu_init(struct axi_drv_cc *cc)
> +{
> +	u32 pmucap;
> +
> +	pmucap = axi_cc_read32(cc, AXI_CC_PMU_CAP);
> +	cc->pmu.rev = (pmucap&  AXI_CC_PMU_CAP_REVISION);
> +
> +	pr_debug("Found rev %u PMU (capabilities 0x%08X)\n", cc->pmu.rev,
> +		 pmucap);
> +
> +	if (cc->pmu.rev == 1)
> +		axi_cc_mask32(cc, AXI_CC_PMU_CTL,
> +			      ~AXI_CC_PMU_CTL_NOILPONW);
> +	else
> +		axi_cc_set32(cc, AXI_CC_PMU_CTL,
> +			     AXI_CC_PMU_CTL_NOILPONW);
> +
> +	if (cc->core->id.id == 0x4329&&  cc->core->id.rev == 2)
> +		pr_err("Fix for 4329b0 bad LPOM state not implemented!\n");
> +
> +	axi_pmu_pll_init(cc);
> +	axi_pmu_resources_init(cc);
> +	axi_pmu_swreg_init(cc);
> +	axi_pmu_workarounds(cc);
> +}
> diff --git a/drivers/axi/driver_pci.c b/drivers/axi/driver_pci.c
> new file mode 100644
> index 0000000..fc4ab25
> --- /dev/null
> +++ b/drivers/axi/driver_pci.c
> @@ -0,0 +1,163 @@
> +/*
> + * AMBA AXI
> + * PCI Core
> + *
> + * Copyright 2005, Broadcom Corporation
> + * Copyright 2006, 2007, Michael Buesch<mb@bu3sch.de>
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "axi_private.h"
> +#include<linux/axi/axi.h>

#include <linux/delay.h>


Are you compiling for i386 architecture? For some reason, delay.h is not 
included for my x86_64 system, and the include is needed for core.c and 
driver_pci.c.

Larry
