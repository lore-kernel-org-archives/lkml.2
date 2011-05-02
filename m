Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1EBHG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 03:06:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1EBHG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 03:06:26 -0400
Message-ID: <4DBE57EE.7060608@monstr.eu>
Date: Mon, 02 May 2011 09:06:22 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
References: <20110502045207.24800.91172.stgit@ponder> <20110502050800.24800.13738.stgit@ponder>
In-Reply-To: <20110502050800.24800.13738.stgit@ponder>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> The 1st board support is minimal to get a system up and running
> on the Xilinx platform.
> 
> This platform reuses the clock implementation from plat-versatile, and
> it depends entirely on CONFIG_OF support.  There is only one board
> support file which obtains all device information from a device tree
> dtb file which is passed to the kernel at boot time.
> 
> Signed-off-by: John Linn <john.linn@xilinx.com>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  Documentation/devicetree/bindings/arm/xilinx.txt |    7 +
>  arch/arm/Kconfig                                 |   14 +
>  arch/arm/Makefile                                |    2 
>  arch/arm/boot/dts/zynq-ep107.dts                 |   52 ++++
>  arch/arm/mach-zynq/Makefile                      |    6 
>  arch/arm/mach-zynq/Makefile.boot                 |    3 
>  arch/arm/mach-zynq/board_dt.c                    |   36 +++
>  arch/arm/mach-zynq/common.c                      |  112 ++++++++
>  arch/arm/mach-zynq/common.h                      |   29 ++
>  arch/arm/mach-zynq/include/mach/clkdev.h         |   32 ++
>  arch/arm/mach-zynq/include/mach/debug-macro.S    |   36 +++
>  arch/arm/mach-zynq/include/mach/entry-macro.S    |   30 ++
>  arch/arm/mach-zynq/include/mach/hardware.h       |   18 +
>  arch/arm/mach-zynq/include/mach/io.h             |   33 ++
>  arch/arm/mach-zynq/include/mach/irqs.h           |   21 ++
>  arch/arm/mach-zynq/include/mach/memory.h         |   22 ++
>  arch/arm/mach-zynq/include/mach/system.h         |   28 ++
>  arch/arm/mach-zynq/include/mach/timex.h          |   23 ++
>  arch/arm/mach-zynq/include/mach/uart.h           |   25 ++
>  arch/arm/mach-zynq/include/mach/uncompress.h     |   51 ++++
>  arch/arm/mach-zynq/include/mach/vmalloc.h        |   20 +
>  arch/arm/mach-zynq/include/mach/zynq_soc.h       |   48 ++++
>  arch/arm/mach-zynq/timer.c                       |  298 ++++++++++++++++++++++
>  arch/arm/mm/Kconfig                              |    2 
>  24 files changed, 947 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/xilinx.txt
>  create mode 100644 arch/arm/boot/dts/zynq-ep107.dts
>  create mode 100644 arch/arm/mach-zynq/Makefile
>  create mode 100644 arch/arm/mach-zynq/Makefile.boot
>  create mode 100644 arch/arm/mach-zynq/board_dt.c
>  create mode 100644 arch/arm/mach-zynq/common.c
>  create mode 100644 arch/arm/mach-zynq/common.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/debug-macro.S
>  create mode 100644 arch/arm/mach-zynq/include/mach/entry-macro.S
>  create mode 100644 arch/arm/mach-zynq/include/mach/hardware.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/io.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/irqs.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/memory.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/system.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/timex.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/uart.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/vmalloc.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h
>  create mode 100644 arch/arm/mach-zynq/timer.c
> 
> diff --git a/Documentation/devicetree/bindings/arm/xilinx.txt b/Documentation/devicetree/bindings/arm/xilinx.txt
> new file mode 100644
> index 0000000..6f1ed830
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/xilinx.txt
> @@ -0,0 +1,7 @@
> +Xilinx Zynq EP107 Emulation Platform board
> +
> +This board is an emulation platform for the Zynq product which is
> +based on an ARM Cortex A9 processor.
> +
> +Required root node properties:
> +    - compatible = "xlnx,zynq-ep107";
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index efc7f3c..3b22878 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -889,6 +889,20 @@ config ARCH_VT8500
>  	select HAVE_PWM
>  	help
>  	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
> +
> +config ARCH_ZYNQ
> +	bool "Xilinx Zynq ARM Cortex A9 Platform"
> +	select CPU_V7
> +	select GENERIC_TIME
> +	select GENERIC_CLOCKEVENTS
> +	select CLKDEV_LOOKUP
> +	select ARM_GIC
> +	select ARM_AMBA
> +	select ICST
> +	select USE_OF
> +	help
> +	  Support for Xilinx Zynq ARM Cortex A9 Platform
> +
>  endchoice
>  
>  #
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index c7d321a..06234de 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -201,6 +201,7 @@ machine-$(CONFIG_MACH_SPEAR300)		:= spear3xx
>  machine-$(CONFIG_MACH_SPEAR310)		:= spear3xx
>  machine-$(CONFIG_MACH_SPEAR320)		:= spear3xx
>  machine-$(CONFIG_MACH_SPEAR600)		:= spear6xx
> +machine-$(CONFIG_ARCH_ZYNQ)		:= zynq
>  
>  # Platform directory name.  This list is sorted alphanumerically
>  # by CONFIG_* macro name.
> @@ -209,6 +210,7 @@ plat-$(CONFIG_ARCH_OMAP)	:= omap
>  plat-$(CONFIG_ARCH_S3C64XX)	:= samsung
>  plat-$(CONFIG_ARCH_STMP3XXX)	:= stmp3xxx
>  plat-$(CONFIG_ARCH_TCC_926)	:= tcc
> +plat-$(CONFIG_ARCH_ZYNQ)	:= versatile
>  plat-$(CONFIG_PLAT_IOP)		:= iop
>  plat-$(CONFIG_PLAT_NOMADIK)	:= nomadik
>  plat-$(CONFIG_PLAT_ORION)	:= orion
> diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-ep107.dts
> new file mode 100644
> index 0000000..37ca192
> --- /dev/null
> +++ b/arch/arm/boot/dts/zynq-ep107.dts
> @@ -0,0 +1,52 @@
> +/*
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +/dts-v1/;
> +/ {
> +	model = "Xilinx Zynq EP107";
> +	compatible = "xlnx,zynq-ep107";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	interrupt-parent = <&intc>;
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x0 0x10000000>;
> +	};
> +
> +	chosen {
> +		bootargs = "console=ttyPS0,9600 root=/dev/ram rw initrd=0x800000,8M earlyprintk";
> +		linux,stdout-path = &uart0;
> +	};
> +
> +	amba {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		intc: interrupt-controller@f8f01000 {
> +			interrupt-controller;
> +			compatible = "arm,gic";
> +			reg = <0xF8F01000 0x1000>;
> +			#interrupt-cells = <2>;
> +		};
> +
> +		uart0: uart@e0000000 {
> +			compatible = "xlnx,xuartps";
> +			reg = <0xE0000000 0x1000>;
> +			interrupts = <59 0>;
> +			clock = <50000000>;
> +		};
> +	};
> +};
> diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
> new file mode 100644
> index 0000000..c550c67
> --- /dev/null
> +++ b/arch/arm/mach-zynq/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for the linux kernel.
> +#
> +
> +# Common support
> +obj-y 				:= common.o timer.o board_dt.o
> diff --git a/arch/arm/mach-zynq/Makefile.boot b/arch/arm/mach-zynq/Makefile.boot
> new file mode 100644
> index 0000000..67039c3
> --- /dev/null
> +++ b/arch/arm/mach-zynq/Makefile.boot
> @@ -0,0 +1,3 @@
> +   zreladdr-y	:= 0x00008000
> +params_phys-y	:= 0x00000100
> +initrd_phys-y	:= 0x00800000
> diff --git a/arch/arm/mach-zynq/board_dt.c b/arch/arm/mach-zynq/board_dt.c
> new file mode 100644
> index 0000000..668f465
> --- /dev/null
> +++ b/arch/arm/mach-zynq/board_dt.c
> @@ -0,0 +1,36 @@
> +/*
> + * This file contains code for boards with device tree support.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * based on arch/arm/mach-realview/core.c
> + *
> + *  Copyright (C) 1999 - 2003 ARM Limited
> + *  Copyright (C) 2000 Deep Blue Solutions Ltd
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of.h>
> +#include <asm/mach/arch.h>
> +#include "common.h"
> +
> +static const char *xilinx_dt_match[] = {
> +	"xlnx,zynq-ep107",
> +	NULL
> +};
> +
> +DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
> +	.map_io		= xilinx_map_io,
> +	.init_irq	= xilinx_irq_init,
> +	.init_machine	= xilinx_init_machine,
> +	.timer		= &xttcpss_sys_timer,
> +	.dt_compat	= xilinx_dt_match,
> +MACHINE_END
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> new file mode 100644
> index 0000000..3b31376
> --- /dev/null
> +++ b/arch/arm/mach-zynq/common.c
> @@ -0,0 +1,112 @@
> +/*
> + * This file contains common code that is intended to be used across
> + * boards so that it's not replicated.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/cpumask.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +
> +#include <asm/mach/map.h>
> +#include <asm/page.h>
> +#include <asm/hardware/gic.h>
> +#include <asm/hardware/cache-l2x0.h>
> +
> +#include <mach/zynq_soc.h>
> +#include <mach/clkdev.h>
> +#include "common.h"
> +
> +static struct of_device_id zynq_of_bus_ids[] __initdata = {
> +	{ .compatible = "simple-bus", },
> +	{}
> +};
> +
> +static struct of_device_id gic_match[] = {
> +	{ .compatible = "arm,gic", },
> +	{}
> +};
> +
> +/**
> + * xilinx_init_machine() - System specific initialization, intended to be
> + *			   called from board specific initialization.
> + */
> +void __init xilinx_init_machine(void)
> +{
> +	struct device_node *node = of_find_matching_node(NULL, gic_match);
> +
> +	if (node)
> +		of_irq_domain_add_simple(node, 0, NR_IRQS);
> +
> +#ifdef CONFIG_CACHE_L2X0
> +	/*
> +	 * 64KB way size, 8-way associativity, parity disabled
> +	 */
> +	l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
> +#endif
> +
> +	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
> +}
> +
> +/**
> + * xilinx_irq_init() - Interrupt controller initialization for the GIC.
> + */
> +void __init xilinx_irq_init(void)
> +{
> +	gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
> +}
> +
> +/* The minimum devices needed to be mapped before the VM system is up and
> + * running include the GIC, UART and Timer Counter.
> + */
> +
> +static struct map_desc io_desc[] __initdata = {
> +	{
> +		.virtual	= TTC0_VIRT,
> +		.pfn		= __phys_to_pfn(TTC0_PHYS),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual	= SCU_PERIPH_VIRT,
> +		.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
> +		.length		= SZ_8K,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual	= PL310_L2CC_VIRT,
> +		.pfn		= __phys_to_pfn(PL310_L2CC_PHYS),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE,
> +	},
> +
> +#ifdef CONFIG_DEBUG_LL
> +	{
> +		.virtual	= UART0_VIRT,
> +		.pfn		= __phys_to_pfn(UART0_PHYS),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE,
> +	},
> +#endif
> +
> +};

look below

> +
> +/**
> + * xilinx_map_io() - Create memory mappings needed for early I/O.
> + */
> +void __init xilinx_map_io(void)
> +{
> +	iotable_init(io_desc, ARRAY_SIZE(io_desc));
> +}
> diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
> new file mode 100644
> index 0000000..bca2196
> --- /dev/null
> +++ b/arch/arm/mach-zynq/common.h
> @@ -0,0 +1,29 @@
> +/*
> + * This file contains common function prototypes to avoid externs
> + * in the c files.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_ZYNQ_COMMON_H__
> +#define __MACH_ZYNQ_COMMON_H__
> +
> +#include <linux/init.h>
> +#include <asm/mach/time.h>
> +
> +extern void xilinx_init_machine(void);
> +extern void xilinx_irq_init(void);
> +extern void xilinx_map_io(void);
> +
> +extern struct sys_timer xttcpss_sys_timer;
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/clkdev.h b/arch/arm/mach-zynq/include/mach/clkdev.h
> new file mode 100644
> index 0000000..c6e73d8
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/clkdev.h
> @@ -0,0 +1,32 @@
> +/*
> + * arch/arm/mach-zynq/include/mach/clkdev.h
> + *
> + *  Copyright (C) 2011 Xilinx, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __MACH_CLKDEV_H__
> +#define __MACH_CLKDEV_H__
> +
> +#include <plat/clock.h>
> +
> +struct clk {
> +	unsigned long		rate;
> +	const struct clk_ops	*ops;
> +	const struct icst_params *params;
> +	void __iomem		*vcoreg;
> +};
> +
> +#define __clk_get(clk) ({ 1; })
> +#define __clk_put(clk) do { } while (0)
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/debug-macro.S b/arch/arm/mach-zynq/include/mach/debug-macro.S
> new file mode 100644
> index 0000000..9f664d5
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/debug-macro.S
> @@ -0,0 +1,36 @@
> +/* arch/arm/mach-zynq/include/mach/debug-macro.S
> + *
> + * Debugging macro include header
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <mach/zynq_soc.h>
> +#include <mach/uart.h>
> +
> +		.macro	addruart, rp, rv
> +		ldr	\rp, =LL_UART_PADDR	@ physical
> +		ldr	\rv, =LL_UART_VADDR	@ virtual
> +		.endm
> +
> +		.macro	senduart,rd,rx
> +		str	\rd, [\rx, #UART_FIFO_OFFSET]	@ TXDATA
> +		.endm
> +
> +		.macro	waituart,rd,rx
> +		.endm
> +
> +		.macro	busyuart,rd,rx
> +1002:		ldr	\rd, [\rx, #UART_SR_OFFSET]	@ get status register
> +		tst	\rd, #UART_SR_TXFULL		@
> +		bne	1002b			@ wait if FIFO is full
> +		.endm
> diff --git a/arch/arm/mach-zynq/include/mach/entry-macro.S b/arch/arm/mach-zynq/include/mach/entry-macro.S
> new file mode 100644
> index 0000000..3cfc01b
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/entry-macro.S
> @@ -0,0 +1,30 @@
> +/*
> + * arch/arm/mach-zynq/include/mach/entry-macro.S
> + *
> + * Low-level IRQ helper macros
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * based on arch/plat-mxc/include/mach/entry-macro.S
> + *
> + *  Copyright (C) 2007 Lennert Buytenhek <buytenh@wantstofly.org>
> + *  Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <mach/hardware.h>
> +#include <asm/hardware/entry-macro-gic.S>
> +
> +		.macro  disable_fiq
> +		.endm
> +
> +		.macro  arch_ret_to_user, tmp1, tmp2
> +		.endm
> diff --git a/arch/arm/mach-zynq/include/mach/hardware.h b/arch/arm/mach-zynq/include/mach/hardware.h
> new file mode 100644
> index 0000000..d558d8a
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/hardware.h
> @@ -0,0 +1,18 @@
> +/* arch/arm/mach-zynq/include/mach/hardware.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_HARDWARE_H__
> +#define __MACH_HARDWARE_H__
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/io.h b/arch/arm/mach-zynq/include/mach/io.h
> new file mode 100644
> index 0000000..39d9885
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/io.h
> @@ -0,0 +1,33 @@
> +/* arch/arm/mach-zynq/include/mach/io.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_IO_H__
> +#define __MACH_IO_H__
> +
> +/* Allow IO space to be anywhere in the memory */
> +
> +#define IO_SPACE_LIMIT 0xffff
> +
> +/* IO address mapping macros, nothing special at this time but required */
> +
> +#ifdef __ASSEMBLER__
> +#define IOMEM(x)		(x)
> +#else
> +#define IOMEM(x)		((void __force __iomem *)(x))
> +#endif
> +
> +#define __io(a)			__typesafe_io(a)
> +#define __mem_pci(a)		(a)
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/irqs.h b/arch/arm/mach-zynq/include/mach/irqs.h
> new file mode 100644
> index 0000000..5fb04fd
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/irqs.h
> @@ -0,0 +1,21 @@
> +/* arch/arm/mach-zynq/include/mach/irqs.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_IRQS_H
> +#define __MACH_IRQS_H
> +
> +#define ARCH_NR_GPIOS	118
> +#define NR_IRQS		(128 + ARCH_NR_GPIOS)
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/memory.h b/arch/arm/mach-zynq/include/mach/memory.h
> new file mode 100644
> index 0000000..35a9263
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/memory.h
> @@ -0,0 +1,22 @@
> +/* arch/arm/mach-zynq/include/mach/memory.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_MEMORY_H__
> +#define __MACH_MEMORY_H__
> +
> +#include <asm/sizes.h>
> +
> +#define PLAT_PHYS_OFFSET	UL(0x0)
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/system.h b/arch/arm/mach-zynq/include/mach/system.h
> new file mode 100644
> index 0000000..1b84d70
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/system.h
> @@ -0,0 +1,28 @@
> +/* arch/arm/mach-zynq/include/mach/system.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_SYSTEM_H__
> +#define __MACH_SYSTEM_H__
> +
> +static inline void arch_idle(void)
> +{
> +	cpu_do_idle();
> +}
> +
> +static inline void arch_reset(char mode, const char *cmd)
> +{
> +	/* Add architecture specific reset processing here */
> +}
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/timex.h b/arch/arm/mach-zynq/include/mach/timex.h
> new file mode 100644
> index 0000000..6c0245e
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/timex.h
> @@ -0,0 +1,23 @@
> +/* arch/arm/mach-zynq/include/mach/timex.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_TIMEX_H__
> +#define __MACH_TIMEX_H__
> +
> +/* the following is needed for the system to build but will be removed
> +   in the future, the value is not important but won't hurt
> +*/
> +#define CLOCK_TICK_RATE	(100 * HZ)
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/uart.h b/arch/arm/mach-zynq/include/mach/uart.h
> new file mode 100644
> index 0000000..5c47c97
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/uart.h
> @@ -0,0 +1,25 @@
> +/* arch/arm/mach-zynq/include/mach/uart.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_UART_H__
> +#define __MACH_UART_H__
> +
> +#define UART_CR_OFFSET		0x00  /* Control Register [8:0] */
> +#define UART_SR_OFFSET		0x2C  /* Channel Status [11:0] */
> +#define UART_FIFO_OFFSET	0x30  /* FIFO [15:0] or [7:0] */
> +
> +#define UART_SR_TXFULL		0x00000010	/* TX FIFO full */
> +#define UART_SR_TXEMPTY		0x00000008	/* TX FIFO empty */
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/uncompress.h b/arch/arm/mach-zynq/include/mach/uncompress.h
> new file mode 100644
> index 0000000..af4e844
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/uncompress.h
> @@ -0,0 +1,51 @@
> +/* arch/arm/mach-zynq/include/mach/uncompress.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_UNCOMPRESS_H__
> +#define __MACH_UNCOMPRESS_H__
> +
> +#include <linux/io.h>
> +#include <asm/processor.h>
> +#include <mach/zynq_soc.h>
> +#include <mach/uart.h>
> +
> +void arch_decomp_setup(void)
> +{
> +}
> +
> +static inline void flush(void)
> +{
> +	/*
> +	 * Wait while the FIFO is not empty
> +	 */
> +	while (!(__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
> +		UART_SR_TXEMPTY))
> +		cpu_relax();
> +}
> +
> +#define arch_decomp_wdog()
> +
> +static void putc(char ch)
> +{
> +	/*
> +	 * Wait for room in the FIFO, then write the char into the FIFO
> +	 */
> +	while (__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
> +		UART_SR_TXFULL)
> +		cpu_relax();
> +
> +	__raw_writel(ch, IOMEM(LL_UART_PADDR + UART_FIFO_OFFSET));
> +}
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/vmalloc.h b/arch/arm/mach-zynq/include/mach/vmalloc.h
> new file mode 100644
> index 0000000..2398eff
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/vmalloc.h
> @@ -0,0 +1,20 @@
> +/* arch/arm/mach-zynq/include/mach/vmalloc.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_VMALLOC_H__
> +#define __MACH_VMALLOC_H__
> +
> +#define VMALLOC_END       0xE0000000UL
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> new file mode 100644
> index 0000000..d0d3f8f
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> @@ -0,0 +1,48 @@
> +/* arch/arm/mach-zynq/include/mach/zynq_soc.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_XILINX_SOC_H__
> +#define __MACH_XILINX_SOC_H__
> +
> +#define PERIPHERAL_CLOCK_RATE		2500000

I think this should be moved to DTS too.

> +
> +/* For now, all mappings are flat (physical = virtual)
> + */
> +#define UART0_PHYS			0xE0000000
> +#define UART0_VIRT			UART0_PHYS

I am not quite sure if is depend entirely on DTS. Why is here physical uart 
address? I don't know how you handle DT in arm but seems to me that the whole 
io_desc structure should go away too.

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
