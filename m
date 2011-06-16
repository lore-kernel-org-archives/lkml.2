Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1FPPmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:42:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38445 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1FPPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:42:06 -0400
Date: Thu, 16 Jun 2011 09:42:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 11/11] arm/versatile: Add device tree support
Message-ID: <20110616154202.GD3795@ponder.secretlab.ca>
References: <20110616042653.29371.2052.stgit@ponder>
 <20110616044311.29371.49018.stgit@ponder>
 <4DFA10DF.10305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFA10DF.10305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:19:11AM -0500, Rob Herring wrote:
> On 06/15/2011 11:43 PM, Grant Likely wrote:
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/versatile-ab.dts
> > @@ -0,0 +1,185 @@
> > +/dts-v1/;
> > +/include/ "skeleton.dtsi"
> > +
> > +/ {
> > +	model = "ARM Versatile AB";
> > +	compatible = "arm,versatile-ab";
> > +	#address-cells = <1>;
> > +	#size-cells = <1>;
> > +	interrupt-parent = <&vic>;
> > +
> > +	memory {
> > +		reg = <0x0 0x08000000>;
> > +	};
> > +
> > +	flash@34000000 {
> > +		compatible = "arm,versatile-flash";
> 
> Seems like this should be a flash part number.

Indeed it should.  I haven't looked up the details of the flash device
yet though.  The DT physmap binding needs to be implemented here too
so that partitions can be described.

> > +		dma@10130000 {
> > +			compatible = "arm,primecell";
> 
> Should have a more specific compatible string. arm,pl081 IIRC?

Probably.  I've not looked up the details in the versatile
documentation yet though.

> 
> > +			reg = <0x10130000 0x1000>;
> > +			interrupts = <17>;
> > +		};
> > +
> > +		uart0: uart@101f1000 {
> > +			compatible = "arm,pl011", "arm,primecell";
> > +			reg = <0x101f1000 0x1000>;
> > +			interrupts = <12>;
> > +		};
> > +
> > +		uart1: uart@101f2000 {
> > +			compatible = "arm,pl011", "arm,primecell";
> > +			reg = <0x101f2000 0x1000>;
> > +			interrupts = <13>;
> > +		};
> > +
> > +		uart2: uart@101f3000 {
> > +			compatible = "arm,pl011", "arm,primecell";
> > +			reg = <0x101f3000 0x1000>;
> > +			interrupts = <14>;
> > +		};
> > +
> > +		smc@10100000 {
> > +			compatible = "arm,primecell";
> 
> ditto
> 
> > +			reg = <0x10100000 0x1000>;
> > +		};
> > +
> > +		mpmc@10110000 {
> > +			compatible = "arm,primecell";
> > +			reg = <0x10110000 0x1000>;
> > +		};
> > +
> > +		display@10120000 {
> > +			compatible = "arm,pl110", "arm,primecell";
> > +			reg = <0x10120000 0x1000>;
> > +			interrupts = <16>;
> > +		};
> > +
> > +		sctl@101e0000 {
> > +			compatible = "arm,primecell";
> > +			reg = <0x101e0000 0x1000>;
> > +		};
> > +
> > +		watchdog@101e1000 {
> > +			compatible = "arm,primecell";
> > +			reg = <0x101e1000 0x1000>;
> > +			interrupts = <0>;
> > +		};
> > +
> > +		gpio0: gpio@101e4000 {
> > +			compatible = "arm,primecell";
> 
> arm,pl061
> 
> > +			reg = <0x101e4000 0x1000>;
> > +			gpio-controller;
> > +			interrupts = <6>;
> > +			#gpio-cells = <2>;
> > +			interrupt-controller;
> > +			#interrupt-cells = <2>;
> > +		};
> > +
> > +		gpio1: gpio@101e5000 {
> > +			compatible = "arm,primecell";
> > +			reg = <0x101e5000 0x1000>;
> > +			interrupts = <7>;
> > +			gpio-controller;
> > +			#gpio-cells = <2>;
> > +			interrupt-controller;
> > +			#interrupt-cells = <2>;
> > +		};
> > +
> > +		rtc@101e8000 {
> > +			compatible = "arm,primecell";
> 
> arm,pl031 (or pl030?)
> 
> > +			reg = <0x101e8000 0x1000>;
> > +			interrupts = <10>;
> > +		};
> > +
> > +		sci@101f0000 {
> > +			compatible = "arm,primecell";
> > +			reg = <0x101f0000 0x1000>;
> > +			interrupts = <15>;
> > +		};
> > +
> > +		ssp@101f4000 {
> > +			compatible = "arm,primecell";
> 
> arm,pl022
> 
> > +			reg = <0x101f4000 0x1000>;
> > +			interrupts = <11>;
> > +		};
> > +
> > +		fpga {
> > +			compatible = "arm,versatile-fpga", "simple-bus";
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			ranges = <0 0x10000000 0x10000>;
> > +
> > +			aaci@4000 {
> > +				compatible = "arm,primecell";
> > +				reg = <0x4000 0x1000>;
> > +				interrupts = <24>;
> > +			};
> > +			mmc@5000 {
> > +				compatible = "arm,primecell";
> > +				reg = < 0x5000 0x1000>;
> > +				interrupts = <22>;
> > +			};
> > +			kmi@6000 {
> > +				compatible = "arm,pl050", "arm,primecell";
> > +				reg = <0x6000 0x1000>;
> > +				interrupt-parent = <&sic>;
> > +				interrupts = <3>;
> > +			};
> > +			kmi@7000 {
> > +				compatible = "arm,pl050", "arm,primecell";
> > +				reg = <0x7000 0x1000>;
> > +				interrupt-parent = <&sic>;
> > +				interrupts = <4>;
> > +			};
> > +		};
> > +	};
> > +};
> > diff --git a/arch/arm/boot/dts/versatile-pb.dts b/arch/arm/boot/dts/versatile-pb.dts
> > new file mode 100644
> > index 0000000..d1934af
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/versatile-pb.dts
> > @@ -0,0 +1,48 @@
> > +/include/ "versatile-ab.dts"
> > +
> > +/ {
> > +	model = "ARM Versatile PB";
> > +	compatible = "arm,versatile-pb";
> > +
> > +	amba {
> > +		gpio2: gpio@101e6000 {
> > +			compatible = "arm,primecell";
> > +			reg = <0x101e6000 0x1000>;
> > +			interrupts = <8>;
> > +			gpio-controller;
> > +			#gpio-cells = <2>;
> > +			interrupt-controller;
> > +			#interrupt-cells = <2>;
> > +		};
> > +
> > +		gpio3: gpio@101e7000 {
> > +			compatible = "arm,primecell";
> > +			reg = <0x101e7000 0x1000>;
> > +			interrupts = <9>;
> > +			gpio-controller;
> > +			#gpio-cells = <2>;
> > +			interrupt-controller;
> > +			#interrupt-cells = <2>;
> > +		};
> > +
> > +		fpga {
> > +			uart@9000 {
> > +				compatible = "arm,pl011", "arm,primecell";
> > +				reg = <0x9000 0x1000>;
> > +				interrupt-parent = <&sic>;
> > +				interrupts = <6>;
> > +			};
> > +			sci@a000 {
> > +				compatible = "arm,primecell";
> > +				reg = <0xa000 0x1000>;
> > +				interrupt-parent = <&sic>;
> > +				interrupts = <5>;
> > +			};
> > +			mmc@b000 {
> > +				compatible = "arm,primecell";
> > +				reg = <0xb000 0x1000>;
> > +				interrupts = <23>;
> > +			};
> > +		};
> > +	};
> > +};
> > diff --git a/arch/arm/mach-versatile/Kconfig b/arch/arm/mach-versatile/Kconfig
> > index 9cdec5a..c1f38f6 100644
> > --- a/arch/arm/mach-versatile/Kconfig
> > +++ b/arch/arm/mach-versatile/Kconfig
> > @@ -17,4 +17,12 @@ config MACH_VERSATILE_AB
> >  	  Include support for the ARM(R) Versatile Application Baseboard
> >  	  for the ARM926EJ-S.
> >  
> > +config MACH_VERSATILE_DT
> > +	bool "Support Versatile platform from device tree"
> > +	select USE_OF
> > +	select CPU_ARM926T
> > +	help
> > +	  Include support for the ARM(R) Versatile/PB platform,
> > +	  using the device tree for discovery
> > +
> >  endmenu
> > diff --git a/arch/arm/mach-versatile/Makefile b/arch/arm/mach-versatile/Makefile
> > index 97cf4d8..81fa3fe 100644
> > --- a/arch/arm/mach-versatile/Makefile
> > +++ b/arch/arm/mach-versatile/Makefile
> > @@ -5,4 +5,5 @@
> >  obj-y					:= core.o
> >  obj-$(CONFIG_ARCH_VERSATILE_PB)		+= versatile_pb.o
> >  obj-$(CONFIG_MACH_VERSATILE_AB)		+= versatile_ab.o
> > +obj-$(CONFIG_MACH_VERSATILE_DT)		+= versatile_dt.o
> >  obj-$(CONFIG_PCI)			+= pci.o
> > diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
> > index 0c99cf0..80e010b 100644
> > --- a/arch/arm/mach-versatile/core.c
> > +++ b/arch/arm/mach-versatile/core.c
> > @@ -24,6 +24,8 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/sysdev.h>
> >  #include <linux/interrupt.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_platform.h>
> >  #include <linux/amba/bus.h>
> >  #include <linux/amba/clcd.h>
> >  #include <linux/amba/pl061.h>
> > @@ -83,13 +85,26 @@ static struct fpga_irq_data sic_irq = {
> >  #define PIC_MASK	0
> >  #endif
> >  
> > +/* Lookup table for finding a DT node that represents the vic instance */
> > +static struct of_device_id vic_of_match[] __initdata = {
> 
> __initconst

fixed, thanks.

> 
> > +	{ .compatible = "arm,vic", },
> > +	{}
> > +};
> > +
> > +static struct of_device_id sic_of_match[] __initdata = {
> 
> ditto
> 
> > +	{ .compatible = "arm,sic", },
> > +	{}
> > +};
> > +
> >  void __init versatile_init_irq(void)
> >  {
> >  	vic_init(VA_VIC_BASE, IRQ_VIC_START, ~0, 0);
> > +	irq_domain_generate_simple(vic_of_match, VERSATILE_VIC_BASE, IRQ_VIC_START);
> >  
> >  	writel(~0, VA_SIC_BASE + SIC_IRQ_ENABLE_CLEAR);
> >  
> >  	fpga_irq_init(IRQ_VICSOURCE31, ~PIC_MASK, &sic_irq);
> > +	irq_domain_generate_simple(sic_of_match, VERSATILE_SIC_BASE, IRQ_SIC_START);
> >  
> >  	/*
> >  	 * Interrupts on secondary controller from 0 to 8 are routed to
> > @@ -646,6 +661,52 @@ static struct amba_device *amba_devs[] __initdata = {
> >  	&kmi1_device,
> >  };
> >  
> > +#ifdef CONFIG_OF
> > +/*
> > + * Lookup table for attaching a specific name and platform_data pointer to
> > + * devices as they get created by of_platform_populate().  Ideally this table
> > + * would not exist, but the current clock implementation depends on some devices
> > + * having a specific name.
> > + */
> > +struct of_dev_auxdata versatile_auxdata_lookup[] __initdata = {
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MMCI0_BASE, "fpga:05", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_KMI0_BASE, "fpga:06", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_KMI1_BASE, "fpga:07", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART3_BASE, "fpga:09", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MMCI1_BASE, "fpga:0b", NULL),
> > +
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_CLCD_BASE, "dev:20", &clcd_plat_data),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART0_BASE, "dev:f1", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART1_BASE, "dev:f2", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART2_BASE, "dev:f3", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SSP_BASE, "dev:f4", NULL),
> > +
> > +#if 0
> > +	/*
> > +	 * These entries are unnecessary because no clocks referencing
> > +	 * them.  I've left them in for now as place holders in case
> > +	 * any of them need to be added back, but they should be
> > +	 * removed before actually committing this patch.  --gcl
> > +	 */
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_AACI_BASE, "fpga:04", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCI1_BASE, "fpga:0a", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SMC_BASE, "dev:00", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MPMC_BASE, "dev:10", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_DMAC_BASE, "dev:30", NULL),
> > +
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCTL_BASE, "dev:e0", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_WATCHDOG_BASE, "dev:e1", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO0_BASE, "dev:e4", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO1_BASE, "dev:e5", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO2_BASE, "dev:e6", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO3_BASE, "dev:e7", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_RTC_BASE, "dev:e8", NULL),
> > +	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCI_BASE, "dev:f0", NULL),
> > +#endif
> > +	{}
> > +};
> > +#endif
> > +
> >  #ifdef CONFIG_LEDS
> >  #define VA_LEDS_BASE (__io_address(VERSATILE_SYS_BASE) + VERSATILE_SYS_LED_OFFSET)
> >  
> > diff --git a/arch/arm/mach-versatile/core.h b/arch/arm/mach-versatile/core.h
> > index fd6404e..c97b070 100644
> > --- a/arch/arm/mach-versatile/core.h
> > +++ b/arch/arm/mach-versatile/core.h
> > @@ -23,6 +23,7 @@
> >  #define __ASM_ARCH_VERSATILE_H
> >  
> >  #include <linux/amba/bus.h>
> > +#include <linux/of_platform.h>
> >  
> >  extern void __init versatile_init(void);
> >  extern void __init versatile_init_early(void);
> > @@ -31,6 +32,10 @@ extern void __init versatile_map_io(void);
> >  extern struct sys_timer versatile_timer;
> >  extern unsigned int mmc_status(struct device *dev);
> >  
> > +#ifdef CONFIG_OF
> 
> Don't really need the ifdef.

True, fixed.

> 
> > +extern struct of_dev_auxdata versatile_auxdata_lookup[];
> > +#endif
> > +
> >  #define AMBA_DEVICE(name,busid,base,plat)			\
> >  static struct amba_device name##_device = {			\
> >  	.dev		= {					\
> > diff --git a/arch/arm/mach-versatile/versatile_dt.c b/arch/arm/mach-versatile/versatile_dt.c
> > new file mode 100644
> > index 0000000..f476a11
> > --- /dev/null
> > +++ b/arch/arm/mach-versatile/versatile_dt.c
> > @@ -0,0 +1,66 @@
> > +/*
> > + * Versatile board support using the device tree
> > + *
> > + *  Copyright (C) 2010 Secret Lab Technologies Ltd.
> > + *  Copyright (C) 2009 Jeremy Kerr <jeremy.kerr@canonical.com>
> > + *  Copyright (C) 2004 ARM Limited
> > + *  Copyright (C) 2000 Deep Blue Solutions Ltd
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/device.h>
> > +#include <linux/sysdev.h>
> > +#include <linux/clk.h>
> > +#include <linux/clkdev.h>
> > +#include <linux/amba/bus.h>
> > +#include <linux/amba/pl061.h>
> > +#include <linux/amba/mmci.h>
> 
> A lot of these headers are not needed.

Trimmed.

> 
> > +#include <linux/io.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_fdt.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/of_platform.h>
> > +
> > +#include <mach/hardware.h>
> > +#include <asm/irq.h>
> > +#include <asm/mach-types.h>
> > +
> > +#include <asm/mach/arch.h>
> > +
> > +#include "core.h"
> > +
> > +static void __init versatile_dt_init(void)
> > +{
> > +	of_platform_populate(NULL, of_default_bus_match_table,
> > +			     versatile_auxdata_lookup, NULL);
> > +}
> > +
> > +static const char *versatile_dt_match[] __initdata = {
> 
> __initconst

fixed.

Thanks,
g.

> 
> > +	"arm,versatile-ab",
> > +	"arm,versatile-pb",
> > +	NULL,
> > +};
> > +
> > +DT_MACHINE_START(VERSATILE_PB, "ARM-Versatile (Device Tree Support)")
> > +	.map_io		= versatile_map_io,
> > +	.init_early	= versatile_init_early,
> > +	.init_irq	= versatile_init_irq,
> > +	.timer		= &versatile_timer,
> > +	.init_machine	= versatile_dt_init,
> > +	.dt_compat	= versatile_dt_match,
> > +MACHINE_END
> > 
> > _______________________________________________
> > devicetree-discuss mailing list
> > devicetree-discuss@lists.ozlabs.org
> > https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
