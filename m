Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1E3Jr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:47:57 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:53556 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1E3Jrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qO55mj1PuqCsi8tz1DdNP2yF6vzA2xYybdQTeG02VfVkzLcYZDocMbN0HwdybOknI9
         A09Cs91x8zD3GF1E2wDg4/UZLiw3CbFMpWUk2fUycfxQUFoI4Aau5Ed9OovgFkxMl7N+
         QOEHOQGxnqH7O/p2ikAdLg3QhmkivCBDw3JNE=
MIME-Version: 1.0
In-Reply-To: <201105261559.41993.arnd@arndb.de>
References: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com>
 <alpine.LFD.2.00.1105241435550.3207@xanadu.home> <BANLkTi=hCpCbNzi1ZiKmGnbhmCG2Ce=EkA@mail.gmail.com>
 <201105261559.41993.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 30 May 2011 17:47:35 +0800
Message-ID: <BANLkTikjMYUCXgBN3UKjpzEg68qOqOHv5A@mail.gmail.com>
Subject: Re: [PATCH] ARM: Xilinx: Adding zynq platform support
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/26 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 25 May 2011, Grant Likely wrote:
>>
>> As per discussion attached below.  Please pull this tree adding device
>> tree support to ARM, plus some other minor device tree changes.
>
> Hi Grant and Linus,
>
> There is also the new Xilinx zynq subarchitecture pending that depends
> on this, see below. Should we also include that right away, in order
> to have an example for other platforms? I think the code is clean
> enough and it would be good to have.
>
>        Arnd
>
> 8<---------
> From: Grant Likely <grant.likely@secretlab.ca>
>
> The 1st board support is minimal to get a system up and running
> on the Xilinx platform.
>
> This platform reuses the clock implementation from plat-versatile, and
> it depends entirely on CONFIG_OF support.  There is only one board
> support file which obtains all device information from a device tree
> dtb file which is passed to the kernel at boot time.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> [john.linn@xilinx.com: Reverted dependency on of_irq_domain patches]
> Signed-off-by: John Linn <john.linn@xilinx.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

is there a whole complete tree for zynq? i'd like to refer. thanks! as
i am moving csr prima2 to device tree, we need to change so many
codes. i hope we can follow what the way zynq is doing.

> ---
>  Documentation/devicetree/bindings/arm/xilinx.txt |    7 +
>  arch/arm/Kconfig                                 |   14 +
>  arch/arm/Makefile                                |    2 +
>  arch/arm/boot/dts/zynq-ep107.dts                 |   52 ++++
>  arch/arm/mach-zynq/Makefile                      |    6 +
>  arch/arm/mach-zynq/Makefile.boot                 |    3 +
>  arch/arm/mach-zynq/board_dt.c                    |   37 +++
>  arch/arm/mach-zynq/common.c                      |  102 ++++++++
>  arch/arm/mach-zynq/common.h                      |   29 ++
>  arch/arm/mach-zynq/include/mach/clkdev.h         |   32 +++
>  arch/arm/mach-zynq/include/mach/debug-macro.S    |   36 +++
>  arch/arm/mach-zynq/include/mach/entry-macro.S    |   30 +++
>  arch/arm/mach-zynq/include/mach/hardware.h       |   18 ++
>  arch/arm/mach-zynq/include/mach/io.h             |   33 +++
>  arch/arm/mach-zynq/include/mach/irqs.h           |   21 ++
>  arch/arm/mach-zynq/include/mach/memory.h         |   22 ++
>  arch/arm/mach-zynq/include/mach/system.h         |   28 ++
>  arch/arm/mach-zynq/include/mach/timex.h          |   23 ++
>  arch/arm/mach-zynq/include/mach/uart.h           |   25 ++
>  arch/arm/mach-zynq/include/mach/uncompress.h     |   51 ++++
>  arch/arm/mach-zynq/include/mach/vmalloc.h        |   20 ++
>  arch/arm/mach-zynq/include/mach/zynq_soc.h       |   48 ++++
>  arch/arm/mach-zynq/timer.c                       |  298 ++++++++++++++++++++++
>  arch/arm/mm/Kconfig                              |    2 +-
>  24 files changed, 938 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/xilinx.txt
>  create mode 100644 arch/arm/boot/dts/zynq-ep107.dts
>  create mode 100644 arch/arm/mach-zynq/Makefile
>  create mode 100644 arch/arm/mach-zynq/Makefile.boot
>  create mode 100644 arch/arm/mach-zynq/board_dt.c
>  create mode 100644 arch/arm/mach-zynq/common.c
>  create mode 100644 arch/arm/mach-zynq/common.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/debug-macro.S
>  create mode 100644 arch/arm/mach-zynq/include/mach/entry-macro.S
>  create mode 100644 arch/arm/mach-zynq/include/mach/hardware.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/io.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/irqs.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/memory.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/system.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/timex.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/uart.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/vmalloc.h
>  create mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h
>  create mode 100644 arch/arm/mach-zynq/timer.c
>
> diff --git a/Documentation/devicetree/bindings/arm/xilinx.txt b/Documentation/devicetree/bindings/arm/xilinx.txt
> new file mode 100644
> index 0000000..6f1ed83
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/xilinx.txt
> @@ -0,0 +1,7 @@
> +Xilinx Zynq EP107 Emulation Platform board
> +
> +This board is an emulation platform for the Zynq product which is
> +based on an ARM Cortex A9 processor.
> +
> +Required root node properties:
> +    - compatible = "xlnx,zynq-ep107";
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 3bc1a58..4a6bc50 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -887,6 +887,20 @@ config ARCH_VT8500
>        select HAVE_PWM
>        help
>          Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
> +
> +config ARCH_ZYNQ
> +       bool "Xilinx Zynq ARM Cortex A9 Platform"
> +       select CPU_V7
> +       select GENERIC_TIME
> +       select GENERIC_CLOCKEVENTS
> +       select CLKDEV_LOOKUP
> +       select ARM_GIC
> +       select ARM_AMBA
> +       select ICST
> +       select USE_OF
> +       help
> +         Support for Xilinx Zynq ARM Cortex A9 Platform
> +
>  endchoice
>
>  #
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 25750bc..bfc3a5a 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -197,6 +197,7 @@ machine-$(CONFIG_MACH_SPEAR300)             := spear3xx
>  machine-$(CONFIG_MACH_SPEAR310)                := spear3xx
>  machine-$(CONFIG_MACH_SPEAR320)                := spear3xx
>  machine-$(CONFIG_MACH_SPEAR600)                := spear6xx
> +machine-$(CONFIG_ARCH_ZYNQ)            := zynq
>
>  # Platform directory name.  This list is sorted alphanumerically
>  # by CONFIG_* macro name.
> @@ -204,6 +205,7 @@ plat-$(CONFIG_ARCH_MXC)             := mxc
>  plat-$(CONFIG_ARCH_OMAP)       := omap
>  plat-$(CONFIG_ARCH_S3C64XX)    := samsung
>  plat-$(CONFIG_ARCH_TCC_926)    := tcc
> +plat-$(CONFIG_ARCH_ZYNQ)       := versatile
>  plat-$(CONFIG_PLAT_IOP)                := iop
>  plat-$(CONFIG_PLAT_NOMADIK)    := nomadik
>  plat-$(CONFIG_PLAT_ORION)      := orion
> diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-ep107.dts
> new file mode 100644
> index 0000000..37ca192
> --- /dev/null
> +++ b/arch/arm/boot/dts/zynq-ep107.dts
> @@ -0,0 +1,52 @@
> +/*
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +/dts-v1/;
> +/ {
> +       model = "Xilinx Zynq EP107";
> +       compatible = "xlnx,zynq-ep107";
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       interrupt-parent = <&intc>;
> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0x0 0x10000000>;
> +       };
> +
> +       chosen {
> +               bootargs = "console=ttyPS0,9600 root=/dev/ram rw initrd=0x800000,8M earlyprintk";
> +               linux,stdout-path = &uart0;
> +       };
> +
> +       amba {
> +               compatible = "simple-bus";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges;
> +
> +               intc: interrupt-controller@f8f01000 {
> +                       interrupt-controller;
> +                       compatible = "arm,gic";
> +                       reg = <0xF8F01000 0x1000>;
> +                       #interrupt-cells = <2>;
> +               };
> +
> +               uart0: uart@e0000000 {
> +                       compatible = "xlnx,xuartps";
> +                       reg = <0xE0000000 0x1000>;
> +                       interrupts = <59 0>;
> +                       clock = <50000000>;
> +               };
> +       };
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
> +obj-y                          := common.o timer.o board_dt.o
> diff --git a/arch/arm/mach-zynq/Makefile.boot b/arch/arm/mach-zynq/Makefile.boot
> new file mode 100644
> index 0000000..67039c3
> --- /dev/null
> +++ b/arch/arm/mach-zynq/Makefile.boot
> @@ -0,0 +1,3 @@
> +   zreladdr-y  := 0x00008000
> +params_phys-y  := 0x00000100
> +initrd_phys-y  := 0x00800000
> diff --git a/arch/arm/mach-zynq/board_dt.c b/arch/arm/mach-zynq/board_dt.c
> new file mode 100644
> index 0000000..5b4710d
> --- /dev/null
> +++ b/arch/arm/mach-zynq/board_dt.c
> @@ -0,0 +1,37 @@
> +/*
> + * This file contains code for boards with device tree support.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * based on arch/arm/mach-realview/core.c
> + *
> + *  Copyright (C) 1999 - 2003 ARM Limited
> + *  Copyright (C) 2000 Deep Blue Solutions Ltd
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach-types.h>
> +#include "common.h"
> +
> +static const char *xilinx_dt_match[] = {
> +       "xlnx,zynq-ep107",
> +       NULL
> +};
> +
> +MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
> +       .map_io         = xilinx_map_io,
> +       .init_irq       = xilinx_irq_init,
> +       .init_machine   = xilinx_init_machine,
> +       .timer          = &xttcpss_sys_timer,
> +       .dt_compat      = xilinx_dt_match,
> +MACHINE_END
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> new file mode 100644
> index 0000000..b3ac5c2
> --- /dev/null
> +++ b/arch/arm/mach-zynq/common.c
> @@ -0,0 +1,102 @@
> +/*
> + * This file contains common code that is intended to be used across
> + * boards so that it's not replicated.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
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
> +       { .compatible = "simple-bus", },
> +       {}
> +};
> +
> +/**
> + * xilinx_init_machine() - System specific initialization, intended to be
> + *                        called from board specific initialization.
> + */
> +void __init xilinx_init_machine(void)
> +{
> +#ifdef CONFIG_CACHE_L2X0
> +       /*
> +        * 64KB way size, 8-way associativity, parity disabled
> +        */
> +       l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
> +#endif
> +
> +       of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
> +}
> +
> +/**
> + * xilinx_irq_init() - Interrupt controller initialization for the GIC.
> + */
> +void __init xilinx_irq_init(void)
> +{
> +       gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
> +}
> +
> +/* The minimum devices needed to be mapped before the VM system is up and
> + * running include the GIC, UART and Timer Counter.
> + */
> +
> +static struct map_desc io_desc[] __initdata = {
> +       {
> +               .virtual        = TTC0_VIRT,
> +               .pfn            = __phys_to_pfn(TTC0_PHYS),
> +               .length         = SZ_4K,
> +               .type           = MT_DEVICE,
> +       }, {
> +               .virtual        = SCU_PERIPH_VIRT,
> +               .pfn            = __phys_to_pfn(SCU_PERIPH_PHYS),
> +               .length         = SZ_8K,
> +               .type           = MT_DEVICE,
> +       }, {
> +               .virtual        = PL310_L2CC_VIRT,
> +               .pfn            = __phys_to_pfn(PL310_L2CC_PHYS),
> +               .length         = SZ_4K,
> +               .type           = MT_DEVICE,
> +       },
> +
> +#ifdef CONFIG_DEBUG_LL
> +       {
> +               .virtual        = UART0_VIRT,
> +               .pfn            = __phys_to_pfn(UART0_PHYS),
> +               .length         = SZ_4K,
> +               .type           = MT_DEVICE,
> +       },
> +#endif
> +
> +};
> +
> +/**
> + * xilinx_map_io() - Create memory mappings needed for early I/O.
> + */
> +void __init xilinx_map_io(void)
> +{
> +       iotable_init(io_desc, ARRAY_SIZE(io_desc));
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
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
> + *  Copyright (C) 2011 Xilinx, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
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
> +       unsigned long           rate;
> +       const struct clk_ops    *ops;
> +       const struct icst_params *params;
> +       void __iomem            *vcoreg;
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <mach/zynq_soc.h>
> +#include <mach/uart.h>
> +
> +               .macro  addruart, rp, rv
> +               ldr     \rp, =LL_UART_PADDR     @ physical
> +               ldr     \rv, =LL_UART_VADDR     @ virtual
> +               .endm
> +
> +               .macro  senduart,rd,rx
> +               str     \rd, [\rx, #UART_FIFO_OFFSET]   @ TXDATA
> +               .endm
> +
> +               .macro  waituart,rd,rx
> +               .endm
> +
> +               .macro  busyuart,rd,rx
> +1002:          ldr     \rd, [\rx, #UART_SR_OFFSET]     @ get status register
> +               tst     \rd, #UART_SR_TXFULL            @
> +               bne     1002b                   @ wait if FIFO is full
> +               .endm
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * based on arch/plat-mxc/include/mach/entry-macro.S
> + *
> + *  Copyright (C) 2007 Lennert Buytenhek <buytenh@wantstofly.org>
> + *  Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <mach/hardware.h>
> +#include <asm/hardware/entry-macro-gic.S>
> +
> +               .macro  disable_fiq
> +               .endm
> +
> +               .macro  arch_ret_to_user, tmp1, tmp2
> +               .endm
> diff --git a/arch/arm/mach-zynq/include/mach/hardware.h b/arch/arm/mach-zynq/include/mach/hardware.h
> new file mode 100644
> index 0000000..d558d8a
> --- /dev/null
> +++ b/arch/arm/mach-zynq/include/mach/hardware.h
> @@ -0,0 +1,18 @@
> +/* arch/arm/mach-zynq/include/mach/hardware.h
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
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
> +#define IOMEM(x)               (x)
> +#else
> +#define IOMEM(x)               ((void __force __iomem *)(x))
> +#endif
> +
> +#define __io(a)                        __typesafe_io(a)
> +#define __mem_pci(a)           (a)
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_IRQS_H
> +#define __MACH_IRQS_H
> +
> +#define ARCH_NR_GPIOS  118
> +#define NR_IRQS                (128 + ARCH_NR_GPIOS)
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_MEMORY_H__
> +#define __MACH_MEMORY_H__
> +
> +#include <asm/sizes.h>
> +
> +#define PLAT_PHYS_OFFSET       UL(0x0)
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_SYSTEM_H__
> +#define __MACH_SYSTEM_H__
> +
> +static inline void arch_idle(void)
> +{
> +       cpu_do_idle();
> +}
> +
> +static inline void arch_reset(char mode, const char *cmd)
> +{
> +       /* Add architecture specific reset processing here */
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_TIMEX_H__
> +#define __MACH_TIMEX_H__
> +
> +/* the following is needed for the system to build but will be removed
> +   in the future, the value is not important but won't hurt
> +*/
> +#define CLOCK_TICK_RATE        (100 * HZ)
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_UART_H__
> +#define __MACH_UART_H__
> +
> +#define UART_CR_OFFSET         0x00  /* Control Register [8:0] */
> +#define UART_SR_OFFSET         0x2C  /* Channel Status [11:0] */
> +#define UART_FIFO_OFFSET       0x30  /* FIFO [15:0] or [7:0] */
> +
> +#define UART_SR_TXFULL         0x00000010      /* TX FIFO full */
> +#define UART_SR_TXEMPTY                0x00000008      /* TX FIFO empty */
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
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
> +       /*
> +        * Wait while the FIFO is not empty
> +        */
> +       while (!(__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
> +               UART_SR_TXEMPTY))
> +               cpu_relax();
> +}
> +
> +#define arch_decomp_wdog()
> +
> +static void putc(char ch)
> +{
> +       /*
> +        * Wait for room in the FIFO, then write the char into the FIFO
> +        */
> +       while (__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
> +               UART_SR_TXFULL)
> +               cpu_relax();
> +
> +       __raw_writel(ch, IOMEM(LL_UART_PADDR + UART_FIFO_OFFSET));
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_VMALLOC_H__
> +#define __MACH_VMALLOC_H__
> +
> +#define VMALLOC_END       0xE0000000UL
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
> + *  Copyright (C) 2011 Xilinx
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MACH_XILINX_SOC_H__
> +#define __MACH_XILINX_SOC_H__
> +
> +#define PERIPHERAL_CLOCK_RATE          2500000
> +
> +/* For now, all mappings are flat (physical = virtual)
> + */
> +#define UART0_PHYS                     0xE0000000
> +#define UART0_VIRT                     UART0_PHYS
> +
> +#define TTC0_PHYS                      0xF8001000
> +#define TTC0_VIRT                      TTC0_PHYS
> +
> +#define PL310_L2CC_PHYS                        0xF8F02000
> +#define PL310_L2CC_VIRT                        PL310_L2CC_PHYS
> +
> +#define SCU_PERIPH_PHYS                        0xF8F00000
> +#define SCU_PERIPH_VIRT                        SCU_PERIPH_PHYS
> +
> +/* The following are intended for the devices that are mapped early */
> +
> +#define TTC0_BASE                      IOMEM(TTC0_VIRT)
> +#define SCU_PERIPH_BASE                        IOMEM(SCU_PERIPH_VIRT)
> +#define SCU_GIC_CPU_BASE               (SCU_PERIPH_BASE + 0x100)
> +#define SCU_GIC_DIST_BASE              (SCU_PERIPH_BASE + 0x1000)
> +#define PL310_L2CC_BASE                        IOMEM(PL310_L2CC_VIRT)
> +
> +/*
> + * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
> + */
> +#define LL_UART_PADDR  UART0_PHYS
> +#define LL_UART_VADDR  UART0_VIRT
> +
> +#endif
> diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
> new file mode 100644
> index 0000000..c2c96cc
> --- /dev/null
> +++ b/arch/arm/mach-zynq/timer.c
> @@ -0,0 +1,298 @@
> +/*
> + * This file contains driver for the Xilinx PS Timer Counter IP.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * based on arch/mips/kernel/time.c timer driver
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/types.h>
> +#include <linux/clocksource.h>
> +#include <linux/clockchips.h>
> +#include <linux/io.h>
> +
> +#include <asm/mach/time.h>
> +#include <mach/zynq_soc.h>
> +#include "common.h"
> +
> +#define IRQ_TIMERCOUNTER0      42
> +
> +/*
> + * This driver configures the 2 16-bit count-up timers as follows:
> + *
> + * T1: Timer 1, clocksource for generic timekeeping
> + * T2: Timer 2, clockevent source for hrtimers
> + * T3: Timer 3, <unused>
> + *
> + * The input frequency to the timer module for emulation is 2.5MHz which is
> + * common to all the timer channels (T1, T2, and T3). With a pre-scaler of 32,
> + * the timers are clocked at 78.125KHz (12.8 us resolution).
> + *
> + * The input frequency to the timer module in silicon will be 200MHz. With the
> + * pre-scaler of 32, the timers are clocked at 6.25MHz (160ns resolution).
> + */
> +#define XTTCPSS_CLOCKSOURCE    0       /* Timer 1 as a generic timekeeping */
> +#define XTTCPSS_CLOCKEVENT     1       /* Timer 2 as a clock event */
> +
> +#define XTTCPSS_TIMER_BASE             TTC0_BASE
> +#define XTTCPCC_EVENT_TIMER_IRQ                (IRQ_TIMERCOUNTER0 + 1)
> +/*
> + * Timer Register Offset Definitions of Timer 1, Increment base address by 4
> + * and use same offsets for Timer 2
> + */
> +#define XTTCPSS_CLK_CNTRL_OFFSET       0x00 /* Clock Control Reg, RW */
> +#define XTTCPSS_CNT_CNTRL_OFFSET       0x0C /* Counter Control Reg, RW */
> +#define XTTCPSS_COUNT_VAL_OFFSET       0x18 /* Counter Value Reg, RO */
> +#define XTTCPSS_INTR_VAL_OFFSET                0x24 /* Interval Count Reg, RW */
> +#define XTTCPSS_MATCH_1_OFFSET         0x30 /* Match 1 Value Reg, RW */
> +#define XTTCPSS_MATCH_2_OFFSET         0x3C /* Match 2 Value Reg, RW */
> +#define XTTCPSS_MATCH_3_OFFSET         0x48 /* Match 3 Value Reg, RW */
> +#define XTTCPSS_ISR_OFFSET             0x54 /* Interrupt Status Reg, RO */
> +#define XTTCPSS_IER_OFFSET             0x60 /* Interrupt Enable Reg, RW */
> +
> +#define XTTCPSS_CNT_CNTRL_DISABLE_MASK 0x1
> +
> +/* Setup the timers to use pre-scaling */
> +
> +#define TIMER_RATE (PERIPHERAL_CLOCK_RATE / 32)
> +
> +/**
> + * struct xttcpss_timer - This definition defines local timer structure
> + *
> + * @base_addr: Base address of timer
> + **/
> +struct xttcpss_timer {
> +       void __iomem *base_addr;
> +};
> +
> +static struct xttcpss_timer timers[2];
> +static struct clock_event_device xttcpss_clockevent;
> +
> +/**
> + * xttcpss_set_interval - Set the timer interval value
> + *
> + * @timer:     Pointer to the timer instance
> + * @cycles:    Timer interval ticks
> + **/
> +static void xttcpss_set_interval(struct xttcpss_timer *timer,
> +                                       unsigned long cycles)
> +{
> +       u32 ctrl_reg;
> +
> +       /* Disable the counter, set the counter value  and re-enable counter */
> +       ctrl_reg = __raw_readl(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
> +       ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
> +       __raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
> +
> +       __raw_writel(cycles, timer->base_addr + XTTCPSS_INTR_VAL_OFFSET);
> +
> +       /* Reset the counter (0x10) so that it starts from 0, one-shot
> +          mode makes this needed for timing to be right. */
> +       ctrl_reg |= 0x10;
> +       ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
> +       __raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
> +}
> +
> +/**
> + * xttcpss_clock_event_interrupt - Clock event timer interrupt handler
> + *
> + * @irq:       IRQ number of the Timer
> + * @dev_id:    void pointer to the xttcpss_timer instance
> + *
> + * returns: Always IRQ_HANDLED - success
> + **/
> +static irqreturn_t xttcpss_clock_event_interrupt(int irq, void *dev_id)
> +{
> +       struct clock_event_device *evt = &xttcpss_clockevent;
> +       struct xttcpss_timer *timer = dev_id;
> +
> +       /* Acknowledge the interrupt and call event handler */
> +       __raw_writel(__raw_readl(timer->base_addr + XTTCPSS_ISR_OFFSET),
> +                       timer->base_addr + XTTCPSS_ISR_OFFSET);
> +
> +       evt->event_handler(evt);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static struct irqaction event_timer_irq = {
> +       .name   = "xttcpss clockevent",
> +       .flags  = IRQF_DISABLED | IRQF_TIMER,
> +       .handler = xttcpss_clock_event_interrupt,
> +};
> +
> +/**
> + * xttcpss_timer_hardware_init - Initialize the timer hardware
> + *
> + * Initialize the hardware to start the clock source, get the clock
> + * event timer ready to use, and hook up the interrupt.
> + **/
> +static void __init xttcpss_timer_hardware_init(void)
> +{
> +       /* Setup the clock source counter to be an incrementing counter
> +        * with no interrupt and it rolls over at 0xFFFF. Pre-scale
> +          it by 32 also. Let it start running now.
> +        */
> +       timers[XTTCPSS_CLOCKSOURCE].base_addr = XTTCPSS_TIMER_BASE;
> +
> +       __raw_writel(0x0, timers[XTTCPSS_CLOCKSOURCE].base_addr +
> +                               XTTCPSS_IER_OFFSET);
> +       __raw_writel(0x9, timers[XTTCPSS_CLOCKSOURCE].base_addr +
> +                               XTTCPSS_CLK_CNTRL_OFFSET);
> +       __raw_writel(0x10, timers[XTTCPSS_CLOCKSOURCE].base_addr +
> +                               XTTCPSS_CNT_CNTRL_OFFSET);
> +
> +       /* Setup the clock event timer to be an interval timer which
> +        * is prescaled by 32 using the interval interrupt. Leave it
> +        * disabled for now.
> +        */
> +
> +       timers[XTTCPSS_CLOCKEVENT].base_addr = XTTCPSS_TIMER_BASE + 4;
> +
> +       __raw_writel(0x23, timers[XTTCPSS_CLOCKEVENT].base_addr +
> +                       XTTCPSS_CNT_CNTRL_OFFSET);
> +       __raw_writel(0x9, timers[XTTCPSS_CLOCKEVENT].base_addr +
> +                       XTTCPSS_CLK_CNTRL_OFFSET);
> +       __raw_writel(0x1, timers[XTTCPSS_CLOCKEVENT].base_addr +
> +                       XTTCPSS_IER_OFFSET);
> +
> +       /* Setup IRQ the clock event timer */
> +       event_timer_irq.dev_id = &timers[XTTCPSS_CLOCKEVENT];
> +       setup_irq(XTTCPCC_EVENT_TIMER_IRQ, &event_timer_irq);
> +}
> +
> +/**
> + * __raw_readl_cycles - Reads the timer counter register
> + *
> + * returns: Current timer counter register value
> + **/
> +static cycle_t __raw_readl_cycles(struct clocksource *cs)
> +{
> +       struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKSOURCE];
> +
> +       return (cycle_t)__raw_readl(timer->base_addr +
> +                               XTTCPSS_COUNT_VAL_OFFSET);
> +}
> +
> +
> +/*
> + * Instantiate and initialize the clock source structure
> + */
> +static struct clocksource clocksource_xttcpss = {
> +       .name           = "xttcpss_timer1",
> +       .rating         = 200,                  /* Reasonable clock source */
> +       .read           = __raw_readl_cycles,
> +       .mask           = CLOCKSOURCE_MASK(16),
> +       .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
> +};
> +
> +
> +/**
> + * xttcpss_set_next_event - Sets the time interval for next event
> + *
> + * @cycles:    Timer interval ticks
> + * @evt:       Address of clock event instance
> + *
> + * returns: Always 0 - success
> + **/
> +static int xttcpss_set_next_event(unsigned long cycles,
> +                                       struct clock_event_device *evt)
> +{
> +       struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
> +
> +       xttcpss_set_interval(timer, cycles);
> +       return 0;
> +}
> +
> +/**
> + * xttcpss_set_mode - Sets the mode of timer
> + *
> + * @mode:      Mode to be set
> + * @evt:       Address of clock event instance
> + **/
> +static void xttcpss_set_mode(enum clock_event_mode mode,
> +                                       struct clock_event_device *evt)
> +{
> +       struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
> +       u32 ctrl_reg;
> +
> +       switch (mode) {
> +       case CLOCK_EVT_MODE_PERIODIC:
> +               xttcpss_set_interval(timer, TIMER_RATE / HZ);
> +               break;
> +       case CLOCK_EVT_MODE_ONESHOT:
> +       case CLOCK_EVT_MODE_UNUSED:
> +       case CLOCK_EVT_MODE_SHUTDOWN:
> +               ctrl_reg = __raw_readl(timer->base_addr +
> +                                       XTTCPSS_CNT_CNTRL_OFFSET);
> +               ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
> +               __raw_writel(ctrl_reg,
> +                               timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
> +               break;
> +       case CLOCK_EVT_MODE_RESUME:
> +               ctrl_reg = __raw_readl(timer->base_addr +
> +                                       XTTCPSS_CNT_CNTRL_OFFSET);
> +               ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
> +               __raw_writel(ctrl_reg,
> +                               timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
> +               break;
> +       }
> +}
> +
> +/*
> + * Instantiate and initialize the clock event structure
> + */
> +static struct clock_event_device xttcpss_clockevent = {
> +       .name           = "xttcpss_timer2",
> +       .features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +       .set_next_event = xttcpss_set_next_event,
> +       .set_mode       = xttcpss_set_mode,
> +       .rating         = 200,
> +};
> +
> +/**
> + * xttcpss_timer_init - Initialize the timer
> + *
> + * Initializes the timer hardware and register the clock source and clock event
> + * timers with Linux kernal timer framework
> + **/
> +static void __init xttcpss_timer_init(void)
> +{
> +       xttcpss_timer_hardware_init();
> +       clocksource_register_hz(&clocksource_xttcpss, TIMER_RATE);
> +
> +       /* Calculate the parameters to allow the clockevent to operate using
> +          integer math
> +       */
> +       clockevents_calc_mult_shift(&xttcpss_clockevent, TIMER_RATE, 4);
> +
> +       xttcpss_clockevent.max_delta_ns =
> +               clockevent_delta2ns(0xfffe, &xttcpss_clockevent);
> +       xttcpss_clockevent.min_delta_ns =
> +               clockevent_delta2ns(1, &xttcpss_clockevent);
> +
> +       /* Indicate that clock event is on 1st CPU as SMP boot needs it */
> +
> +       xttcpss_clockevent.cpumask = cpumask_of(0);
> +       clockevents_register_device(&xttcpss_clockevent);
> +}
> +
> +/*
> + * Instantiate and initialize the system timer structure
> + */
> +struct sys_timer xttcpss_sys_timer = {
> +       .init           = xttcpss_timer_init,
> +};
> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index 0074b8d..f046982 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@ -821,7 +821,7 @@ config CACHE_L2X0
>        depends on REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || MACH_REALVIEW_PB1176 || \
>                   REALVIEW_EB_A9MP || SOC_IMX35 || SOC_IMX31 || MACH_REALVIEW_PBX || \
>                   ARCH_NOMADIK || ARCH_OMAP4 || ARCH_EXYNOS4 || ARCH_TEGRA || \
> -                  ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_SHMOBILE
> +                  ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_SHMOBILE || ARCH_ZYNQ
>        default y
>        select OUTER_CACHE
>        select OUTER_CACHE_SYNC
> --
> 1.7.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
