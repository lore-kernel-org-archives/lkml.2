Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab2J0Qr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:47:57 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:24526
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab2J0Qrz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:47:55 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 13
X-BigFish: VPS13(zz9371I542M1432Ic8kzz1202h1d1ah1d2ahzz8275bhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: RE: [PATCH v4 3/5] zynq: remove use of CLKDEV_LOOKUP
Thread-Topic: [PATCH v4 3/5] zynq: remove use of CLKDEV_LOOKUP
Thread-Index: AQHNsiLCZwMG1F4Mmkuz7RXuPeJDGZfNYTfw
Date: Sat, 27 Oct 2012 16:47:49 +0000
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200407.GD6713@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024200407.GD6713@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.65]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <d45357f1-1ccb-4308-aeef-7fe2f1569cb8@CO1EHSMHS001.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Wednesday, October 24, 2012 10:04 PM
> To: arm@kernel.org; Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; John
> Linn; Nick Bowler; Michal Simek
> Subject: [PATCH v4 3/5] zynq: remove use of CLKDEV_LOOKUP
>
> The Zynq support in mainline does not (yet) make use of any of the generic clk
> or clk lookup functionality.  Remove what is upstream for now, until the out-of-
> tree implementation is in suitable form for merging.
>
> An important side effect of this patch is that it allows the building of a Zynq
> kernel without running into unresolved symbol problems:
>
>    drivers/built-in.o: In function `amba_get_enable_pclk':
>    clkdev.c:(.text+0x444): undefined reference to `clk_enable'
>    drivers/built-in.o: In function `amba_remove':
>    clkdev.c:(.text+0x488): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `amba_probe':
>    clkdev.c:(.text+0x540): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `amba_device_add':
>    clkdev.c:(.text+0x77c): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `enable_clock':
>    clkdev.c:(.text+0x29738): undefined reference to `clk_enable'
>    drivers/built-in.o: In function `disable_clock':
>    clkdev.c:(.text+0x29778): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `__pm_clk_remove':
>    clkdev.c:(.text+0x297f8): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `pm_clk_suspend':
>    clkdev.c:(.text+0x29bc8): undefined reference to `clk_disable'
>    drivers/built-in.o: In function `pm_clk_resume':
>    clkdev.c:(.text+0x29c28): undefined reference to `clk_enable'
>    make[2]: *** [vmlinux] Error 1
>    make[1]: *** [sub-make] Error 2
>    make: *** [all] Error 2
>
> In addition, eliminate Zynq's "use" of the versatile platform, as it is no longer
> needed.  As Nick Bowler points out:
>
>    For the record, I think this was introduced by commit 56a34b03ff427
>    ("ARM: versatile: Make plat-versatile clock optional") which forgot to
>    select PLAT_VERSATILE_CLOCK on Zynq.  This is not all that surprising,
>    because the fact that Zynq "uses" PLAT_VERSATILE is secretly hidden in
>    the Makefile.
>
>    Nevertheless, the only feature from versatile that Zynq needed was the
>    clock support, so this patch should *also* delete the secret use of
>    plat-versatile by removing this line from arch/arm/Makefile:
>
>       plat-$(CONFIG_ARCH_ZYNQ)      += versatile
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/Kconfig                         |  1 -
>  arch/arm/Makefile                        |  1 -
>  arch/arm/mach-zynq/common.c              |  1 -
>  arch/arm/mach-zynq/include/mach/clkdev.h | 32 --------------------------------
>  4 files changed, 35 deletions(-)
>  delete mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig index cce4f8d..de70d99 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -946,7 +946,6 @@ config ARCH_ZYNQ
>       bool "Xilinx Zynq ARM Cortex A9 Platform"
>       select ARM_AMBA
>       select ARM_GIC
> -     select CLKDEV_LOOKUP
>       select CPU_V7
>       select GENERIC_CLOCKEVENTS
>       select ICST
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile index 451757d..8dbab2d
> 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -197,7 +197,6 @@ machine-$(CONFIG_ARCH_ZYNQ)               += zynq
>  # by CONFIG_* macro name.
>  plat-$(CONFIG_ARCH_OMAP)     += omap
>  plat-$(CONFIG_ARCH_S3C64XX)  += samsung
> -plat-$(CONFIG_ARCH_ZYNQ)     += versatile
>  plat-$(CONFIG_PLAT_IOP)              += iop
>  plat-$(CONFIG_PLAT_NOMADIK)  += nomadik
>  plat-$(CONFIG_PLAT_ORION)    += orion
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index 056091a..ba48f06 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -31,7 +31,6 @@
>  #include <asm/hardware/cache-l2x0.h>
>
>  #include <mach/zynq_soc.h>
> -#include <mach/clkdev.h>
>  #include "common.h"
>
>  static struct of_device_id zynq_of_bus_ids[] __initdata = { diff --git
> a/arch/arm/mach-zynq/include/mach/clkdev.h b/arch/arm/mach-
> zynq/include/mach/clkdev.h
> deleted file mode 100644
> index c6e73d8..0000000
> --- a/arch/arm/mach-zynq/include/mach/clkdev.h
> +++ /dev/null
> @@ -1,32 +0,0 @@
> -/*
> - * arch/arm/mach-zynq/include/mach/clkdev.h
> - *
> - *  Copyright (C) 2011 Xilinx, Inc.
> - *
> - * This software is licensed under the terms of the GNU General Public
> - * License version 2, as published by the Free Software Foundation, and
> - * may be copied, distributed, and modified under those terms.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - */
> -
> -#ifndef __MACH_CLKDEV_H__
> -#define __MACH_CLKDEV_H__
> -
> -#include <plat/clock.h>
> -
> -struct clk {
> -     unsigned long           rate;
> -     const struct clk_ops    *ops;
> -     const struct icst_params *params;
> -     void __iomem            *vcoreg;
> -};
> -
> -#define __clk_get(clk) ({ 1; })
> -#define __clk_put(clk) do { } while (0)
> -
> -#endif

Tested-by: Michal Simek <michal.simek@xilinx.com>

Thanks
Michal


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


