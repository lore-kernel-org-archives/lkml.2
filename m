Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab2FYQGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:06:55 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38884 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab2FYQGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:06:53 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: ARM: s3c2410: remove dead mach-s3c2410 directory
Date: Mon, 25 Jun 2012 18:06:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1340619112.1773.155.camel@x61.thuisdomein>
In-Reply-To: <1340619112.1773.155.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206251806.28081.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 25 Juni 2012, 12:11:52 schrieb Paul Bolle:
> Commit 85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410: move
> mach-s3c2410/* into mach-s3c24xx/") orphaned
> arch/arm/mach-s3c2410/Kconfig: currently no other Kconfig file sources
> that file. This means that the Kconfig symbols S3C2410_CPUFREQ and
> S3C2410_PLLTABLE will never be set, which in turns means that the macros
> CONFIG_S3C2410_CPUFREQ and CONFIG_S3C2410_PLLTABLE will never be
> defined.
> 
> All this makes that all four files in the mach-directory (Kconfig,
> Makefile, cpu-freq.c, and pll.c) are effectively dead files since v3.4:
> none of them can lead to any code in someones kernel. This directory can
> safely be removed.

I don't think so. CPU-frequency-scaling on the earlier S3C architectures was 
probably working before the beginning of the directory merge.

If I recall correctly Kgene was working on completing these missing pieces of 
the move to mach-s3c24xx.

The reason for noone complaining about the missing cpufreq support yet, might 
be that projects using the early S3C architectures hae not made it to the most 
recent kernel releases.


> Also delete two lines from mach-s3c24xx/Kconfig that now also become
> meaningless.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested only with a number of git commands.
> 
> 1) Previously discussed in https://lkml.org/lkml/2012/4/22/26 .
> 
>  arch/arm/mach-s3c2410/Kconfig    |   20 -----
>  arch/arm/mach-s3c2410/Makefile   |   14 ---
>  arch/arm/mach-s3c2410/cpu-freq.c |  163
> -------------------------------------- arch/arm/mach-s3c2410/pll.c      | 
>  99 -----------------------
>  arch/arm/mach-s3c24xx/Kconfig    |    2 -
>  5 files changed, 0 insertions(+), 298 deletions(-)
>  delete mode 100644 arch/arm/mach-s3c2410/Kconfig
>  delete mode 100644 arch/arm/mach-s3c2410/Makefile
>  delete mode 100644 arch/arm/mach-s3c2410/cpu-freq.c
>  delete mode 100644 arch/arm/mach-s3c2410/pll.c
> 
> diff --git a/arch/arm/mach-s3c2410/Kconfig b/arch/arm/mach-s3c2410/Kconfig
> deleted file mode 100644
> index 68d89cb..0000000
> --- a/arch/arm/mach-s3c2410/Kconfig
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -# Copyright 2007 Simtec Electronics
> -#
> -# Licensed under GPLv2
> -
> -# cpu frequency scaling support
> -
> -config S3C2410_CPUFREQ
> -	bool
> -	depends on CPU_FREQ_S3C24XX && CPU_S3C2410
> -	select S3C2410_CPUFREQ_UTILS
> -	help
> -	  CPU Frequency scaling support for S3C2410
> -
> -config S3C2410_PLLTABLE
> -	bool
> -	depends on S3C2410_CPUFREQ && CPU_FREQ_S3C24XX_PLL
> -	default y
> -	help
> -	  Select the PLL table for the S3C2410
> -
> diff --git a/arch/arm/mach-s3c2410/Makefile
> b/arch/arm/mach-s3c2410/Makefile deleted file mode 100644
> index 6b9a316..0000000
> --- a/arch/arm/mach-s3c2410/Makefile
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -# arch/arm/mach-s3c2410/Makefile
> -#
> -# Copyright 2007 Simtec Electronics
> -#
> -# Licensed under GPLv2
> -
> -obj-y				:=
> -obj-m				:=
> -obj-n				:=
> -obj-				:=
> -
> -obj-$(CONFIG_S3C2410_CPUFREQ)	+= cpu-freq.o
> -obj-$(CONFIG_S3C2410_PLLTABLE)	+= pll.o
> -
> diff --git a/arch/arm/mach-s3c2410/cpu-freq.c
> b/arch/arm/mach-s3c2410/cpu-freq.c deleted file mode 100644
> index 5404535..0000000
> --- a/arch/arm/mach-s3c2410/cpu-freq.c
> +++ /dev/null
> @@ -1,163 +0,0 @@
> -/* linux/arch/arm/mach-s3c2410/cpu-freq.c
> - *
> - * Copyright (c) 2006-2008 Simtec Electronics
> - *	http://armlinux.simtec.co.uk/
> - *	Ben Dooks <ben@simtec.co.uk>
> - *
> - * S3C2410 CPU Frequency scaling
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> -*/
> -
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/interrupt.h>
> -#include <linux/ioport.h>
> -#include <linux/cpufreq.h>
> -#include <linux/device.h>
> -#include <linux/clk.h>
> -#include <linux/err.h>
> -#include <linux/io.h>
> -
> -#include <asm/mach/arch.h>
> -#include <asm/mach/map.h>
> -
> -#include <mach/regs-clock.h>
> -
> -#include <plat/cpu.h>
> -#include <plat/clock.h>
> -#include <plat/cpu-freq-core.h>
> -
> -/* Note, 2410A has an extra mode for 1:4:4 ratio, bit 2 of CLKDIV */
> -
> -static void s3c2410_cpufreq_setdivs(struct s3c_cpufreq_config *cfg)
> -{
> -	u32 clkdiv = 0;
> -
> -	if (cfg->divs.h_divisor == 2)
> -		clkdiv |= S3C2410_CLKDIVN_HDIVN;
> -
> -	if (cfg->divs.p_divisor != cfg->divs.h_divisor)
> -		clkdiv |= S3C2410_CLKDIVN_PDIVN;
> -
> -	__raw_writel(clkdiv, S3C2410_CLKDIVN);
> -}
> -
> -static int s3c2410_cpufreq_calcdivs(struct s3c_cpufreq_config *cfg)
> -{
> -	unsigned long hclk, fclk, pclk;
> -	unsigned int hdiv, pdiv;
> -	unsigned long hclk_max;
> -
> -	fclk = cfg->freq.fclk;
> -	hclk_max = cfg->max.hclk;
> -
> -	cfg->freq.armclk = fclk;
> -
> -	s3c_freq_dbg("%s: fclk is %lu, max hclk %lu\n",
> -		      __func__, fclk, hclk_max);
> -
> -	hdiv = (fclk > cfg->max.hclk) ? 2 : 1;
> -	hclk = fclk / hdiv;
> -
> -	if (hclk > cfg->max.hclk) {
> -		s3c_freq_dbg("%s: hclk too big\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	pdiv = (hclk > cfg->max.pclk) ? 2 : 1;
> -	pclk = hclk / pdiv;
> -
> -	if (pclk > cfg->max.pclk) {
> -		s3c_freq_dbg("%s: pclk too big\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	pdiv *= hdiv;
> -
> -	/* record the result */
> -	cfg->divs.p_divisor = pdiv;
> -	cfg->divs.h_divisor = hdiv;
> -
> -	return 0      ;
> -}
> -
> -static struct s3c_cpufreq_info s3c2410_cpufreq_info = {
> -	.max		= {
> -		.fclk	= 200000000,
> -		.hclk	= 100000000,
> -		.pclk	=  50000000,
> -	},
> -
> -	/* transition latency is about 5ms worst-case, so
> -	 * set 10ms to be sure */
> -	.latency	= 10000000,
> -
> -	.locktime_m	= 150,
> -	.locktime_u	= 150,
> -	.locktime_bits	= 12,
> -
> -	.need_pll	= 1,
> -
> -	.name		= "s3c2410",
> -	.calc_iotiming	= s3c2410_iotiming_calc,
> -	.set_iotiming	= s3c2410_iotiming_set,
> -	.get_iotiming	= s3c2410_iotiming_get,
> -	.resume_clocks	= s3c2410_setup_clocks,
> -
> -	.set_fvco	= s3c2410_set_fvco,
> -	.set_refresh	= s3c2410_cpufreq_setrefresh,
> -	.set_divs	= s3c2410_cpufreq_setdivs,
> -	.calc_divs	= s3c2410_cpufreq_calcdivs,
> -
> -	.debug_io_show	= s3c_cpufreq_debugfs_call(s3c2410_iotiming_debugfs),
> -};
> -
> -static int s3c2410_cpufreq_add(struct device *dev,
> -			       struct subsys_interface *sif)
> -{
> -	return s3c_cpufreq_register(&s3c2410_cpufreq_info);
> -}
> -
> -static struct subsys_interface s3c2410_cpufreq_interface = {
> -	.name		= "s3c2410_cpufreq",
> -	.subsys		= &s3c2410_subsys,
> -	.add_dev	= s3c2410_cpufreq_add,
> -};
> -
> -static int __init s3c2410_cpufreq_init(void)
> -{
> -	return subsys_interface_register(&s3c2410_cpufreq_interface);
> -}
> -
> -arch_initcall(s3c2410_cpufreq_init);
> -
> -static int s3c2410a_cpufreq_add(struct device *dev,
> -				struct subsys_interface *sif)
> -{
> -	/* alter the maximum freq settings for S3C2410A. If a board knows
> -	 * it only has a maximum of 200, then it should register its own
> -	 * limits. */
> -
> -	s3c2410_cpufreq_info.max.fclk = 266000000;
> -	s3c2410_cpufreq_info.max.hclk = 133000000;
> -	s3c2410_cpufreq_info.max.pclk =  66500000;
> -	s3c2410_cpufreq_info.name = "s3c2410a";
> -
> -	return s3c2410_cpufreq_add(dev, sif);
> -}
> -
> -static struct subsys_interface s3c2410a_cpufreq_interface = {
> -	.name		= "s3c2410a_cpufreq",
> -	.subsys		= &s3c2410a_subsys,
> -	.add_dev	= s3c2410a_cpufreq_add,
> -};
> -
> -static int __init s3c2410a_cpufreq_init(void)
> -{
> -	return subsys_interface_register(&s3c2410a_cpufreq_interface);
> -}
> -
> -arch_initcall(s3c2410a_cpufreq_init);
> diff --git a/arch/arm/mach-s3c2410/pll.c b/arch/arm/mach-s3c2410/pll.c
> deleted file mode 100644
> index e0b3b34..0000000
> --- a/arch/arm/mach-s3c2410/pll.c
> +++ /dev/null
> @@ -1,99 +0,0 @@
> -/* arch/arm/mach-s3c2410/pll.c
> - *
> - * Copyright (c) 2006-2007 Simtec Electronics
> - *	http://armlinux.simtec.co.uk/
> - *	Ben Dooks <ben@simtec.co.uk>
> - *	Vincent Sanders <vince@arm.linux.org.uk>
> - *
> - * S3C2410 CPU PLL tables
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA -*/
> -
> -#include <linux/types.h>
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/device.h>
> -#include <linux/list.h>
> -#include <linux/clk.h>
> -#include <linux/err.h>
> -
> -#include <plat/cpu.h>
> -#include <plat/cpu-freq-core.h>
> -
> -static struct cpufreq_frequency_table pll_vals_12MHz[] = {
> -    { .frequency = 34000000,  .index = PLLVAL(82, 2, 3),   },
> -    { .frequency = 45000000,  .index = PLLVAL(82, 1, 3),   },
> -    { .frequency = 51000000,  .index = PLLVAL(161, 3, 3),  },
> -    { .frequency = 48000000,  .index = PLLVAL(120, 2, 3),  },
> -    { .frequency = 56000000,  .index = PLLVAL(142, 2, 3),  },
> -    { .frequency = 68000000,  .index = PLLVAL(82, 2, 2),   },
> -    { .frequency = 79000000,  .index = PLLVAL(71, 1, 2),   },
> -    { .frequency = 85000000,  .index = PLLVAL(105, 2, 2),  },
> -    { .frequency = 90000000,  .index = PLLVAL(112, 2, 2),  },
> -    { .frequency = 101000000, .index = PLLVAL(127, 2, 2),  },
> -    { .frequency = 113000000, .index = PLLVAL(105, 1, 2),  },
> -    { .frequency = 118000000, .index = PLLVAL(150, 2, 2),  },
> -    { .frequency = 124000000, .index = PLLVAL(116, 1, 2),  },
> -    { .frequency = 135000000, .index = PLLVAL(82, 2, 1),   },
> -    { .frequency = 147000000, .index = PLLVAL(90, 2, 1),   },
> -    { .frequency = 152000000, .index = PLLVAL(68, 1, 1),   },
> -    { .frequency = 158000000, .index = PLLVAL(71, 1, 1),   },
> -    { .frequency = 170000000, .index = PLLVAL(77, 1, 1),   },
> -    { .frequency = 180000000, .index = PLLVAL(82, 1, 1),   },
> -    { .frequency = 186000000, .index = PLLVAL(85, 1, 1),   },
> -    { .frequency = 192000000, .index = PLLVAL(88, 1, 1),   },
> -    { .frequency = 203000000, .index = PLLVAL(161, 3, 1),  },
> -
> -    /* 2410A extras */
> -
> -    { .frequency = 210000000, .index = PLLVAL(132, 2, 1),  },
> -    { .frequency = 226000000, .index = PLLVAL(105, 1, 1),  },
> -    { .frequency = 266000000, .index = PLLVAL(125, 1, 1),  },
> -    { .frequency = 268000000, .index = PLLVAL(126, 1, 1),  },
> -    { .frequency = 270000000, .index = PLLVAL(127, 1, 1),  },
> -};
> -
> -static int s3c2410_plls_add(struct device *dev, struct subsys_interface
> *sif) -{
> -	return s3c_plltab_register(pll_vals_12MHz, ARRAY_SIZE(pll_vals_12MHz));
> -}
> -
> -static struct subsys_interface s3c2410_plls_interface = {
> -	.name		= "s3c2410_plls",
> -	.subsys		= &s3c2410_subsys,
> -	.add_dev	= s3c2410_plls_add,
> -};
> -
> -static int __init s3c2410_pll_init(void)
> -{
> -	return subsys_interface_register(&s3c2410_plls_interface);
> -
> -}
> -
> -arch_initcall(s3c2410_pll_init);
> -
> -static struct subsys_interface s3c2410a_plls_interface = {
> -	.name		= "s3c2410a_plls",
> -	.subsys		= &s3c2410a_subsys,
> -	.add_dev	= s3c2410_plls_add,
> -};
> -
> -static int __init s3c2410a_pll_init(void)
> -{
> -	return subsys_interface_register(&s3c2410a_plls_interface);
> -}
> -
> -arch_initcall(s3c2410a_pll_init);
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index e249611..8f0592a 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -20,7 +20,6 @@ config CPU_S3C2410
>  	select S3C2410_CLOCK
>  	select CPU_LLSERIAL_S3C2410
>  	select S3C2410_PM if PM
> -	select S3C2410_CPUFREQ if CPU_FREQ_S3C24XX
>  	help
>  	  Support for S3C2410 and S3C2410A family from the S3C24XX line
>  	  of Samsung Mobile CPUs.
> @@ -156,7 +155,6 @@ config MACH_AML_M5900
> 
>  config ARCH_BAST
>  	bool "Simtec Electronics BAST (EB2410ITX)"
> -	select S3C2410_IOTIMING if S3C2410_CPUFREQ
>  	select S3C24XX_SIMTEC_PM if PM
>  	select S3C24XX_SIMTEC_NOR
>  	select S3C24XX_SIMTEC_USB

