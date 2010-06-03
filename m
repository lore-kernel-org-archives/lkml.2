Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0FCO2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:28:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35008 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0FCO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=pl+VarRbvXMl/+Cs2+PG2bRkoX9EA2JoKWMoKtuLG+rjzDsoKVz66MRzedOK+h/Gdd
         TZZNU/L7gy7ibjCXaRaVTsftkIf5Qxhbwy8GtFdI3VtON+ARAJRGhtS8YA/Q/hKB/GKa
         dMnA4XUgKaKNuPHWE01WMAgLlCtRQJ0Ip1Jt0=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [RFC][PATCH 01/26] MIPS: Add base support for Ingenic JZ4740 System-on-a-Chip
Date: Thu, 3 Jun 2010 16:27:31 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-server; KDE/4.4.2; x86_64; ; )
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
References: <1275505397-16758-1-git-send-email-lars@metafoo.de> <1275505397-16758-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1275505397-16758-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031627.31308.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Wednesday 02 June 2010 21:02:52 Lars-Peter Clausen wrote:
> This patch adds a new cpu type for the JZ4740 to the Linux MIPS
> architecture code. It also adds the iomem addresses for the different
> components found on a JZ4740 SoC.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
[snip]

>  	 * MIPS64 class processors
> diff --git a/arch/mips/include/asm/mach-jz4740/base.h
> b/arch/mips/include/asm/mach-jz4740/base.h new file mode 100644
> index 0000000..cba3aae
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-jz4740/base.h
> @@ -0,0 +1,28 @@
> +#ifndef __ASM_MACH_JZ4740_BASE_H__
> +#define __ASM_MACH_JZ4740_BASE_H__
> +
> +#define JZ4740_CPM_BASE_ADDR	0xb0000000
> +#define JZ4740_INTC_BASE_ADDR	0xb0001000
> +#define JZ4740_TCU_BASE_ADDR	0xb0002000
> +#define JZ4740_WDT_BASE_ADDR	0xb0002000
> +#define JZ4740_RTC_BASE_ADDR	0xb0003000
> +#define JZ4740_GPIO_BASE_ADDR	0xb0010000
> +#define JZ4740_AIC_BASE_ADDR	0xb0020000
> +#define JZ4740_ICDC_BASE_ADDR	0xb0020000
> +#define JZ4740_MSC_BASE_ADDR	0xb0021000
> +#define JZ4740_UART0_BASE_ADDR	0xb0030000
> +#define JZ4740_UART1_BASE_ADDR	0xb0031000
> +#define JZ4740_I2C_BASE_ADDR	0xb0042000
> +#define JZ4740_SSI_BASE_ADDR	0xb0043000
> +#define JZ4740_SADC_BASE_ADDR	0xb0070000
> +#define JZ4740_EMC_BASE_ADDR	0xb3010000
> +#define JZ4740_DMAC_BASE_ADDR	0xb3020000
> +#define JZ4740_UHC_BASE_ADDR	0xb3030000
> +#define JZ4740_UDC_BASE_ADDR	0xb3040000
> +#define JZ4740_LCD_BASE_ADDR	0xb3050000
> +#define JZ4740_SLCD_BASE_ADDR	0xb3050000
> +#define JZ4740_CIM_BASE_ADDR	0xb3060000
> +#define JZ4740_IPU_BASE_ADDR	0xb3080000
> +#define JZ4740_ETH_BASE_ADDR	0xb3100000

Any reasons why you prefered virtual addresses here instead of physical ones?
You might also want to define a "true" base address and compute the registers
offset relatively to this base address for better clarity.

> +
> +#endif
> diff --git a/arch/mips/include/asm/mach-jz4740/war.h
> b/arch/mips/include/asm/mach-jz4740/war.h new file mode 100644
> index 0000000..3a5bc17
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-jz4740/war.h
> @@ -0,0 +1,25 @@
> +/*
> + * This file is subject to the terms and conditions of the GNU General
> Public + * License.  See the file "COPYING" in the main directory of this
> archive + * for more details.
> + *
> + * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
> + */
> +#ifndef __ASM_MIPS_MACH_JZ4740_WAR_H
> +#define __ASM_MIPS_MACH_JZ4740_WAR_H
> +
> +#define R4600_V1_INDEX_ICACHEOP_WAR	0
> +#define R4600_V1_HIT_CACHEOP_WAR	0
> +#define R4600_V2_HIT_CACHEOP_WAR	0
> +#define R5432_CP0_INTERRUPT_WAR		0
> +#define BCM1250_M3_WAR			0
> +#define SIBYTE_1956_WAR			0
> +#define MIPS4K_ICACHE_REFILL_WAR	0
> +#define MIPS_CACHE_SYNC_WAR		0
> +#define TX49XX_ICACHE_INDEX_INV_WAR	0
> +#define RM9000_CDEX_SMP_WAR		0
> +#define ICACHE_REFILLS_WORKAROUND_WAR	0
> +#define R10000_LLSC_WAR			0
> +#define MIPS34K_MISSED_ITLB_WAR		0
> +
> +#endif /* __ASM_MIPS_MACH_JZ4740_WAR_H */
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index 3562b85..9b66331 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -187,6 +187,7 @@ void __init check_wait(void)
>  	case CPU_BCM6358:
>  	case CPU_CAVIUM_OCTEON:
>  	case CPU_CAVIUM_OCTEON_PLUS:
> +	case CPU_JZRISC:
>  		cpu_wait = r4k_wait;
>  		break;
> 
> @@ -956,6 +957,22 @@ platform:
>  	}
>  }
> 
> +static inline void cpu_probe_ingenic(struct cpuinfo_mips *c, unsigned int
> cpu) +{
> +	decode_configs(c);
> +	/* JZRISC does not implement the CP0 counter. */
> +	c->options &= ~MIPS_CPU_COUNTER;
> +	switch (c->processor_id & 0xff00) {
> +	case PRID_IMP_JZRISC:
> +		c->cputype = CPU_JZRISC;
> +		__cpu_name[cpu] = "Ingenic JZRISC";
> +		break;
> +	default:
> +		panic("Unknown Ingenic Processor ID!");
> +		break;
> +	}
> +}
> +
>  const char *__cpu_name[NR_CPUS];
>  const char *__elf_platform;
> 
> @@ -994,6 +1011,9 @@ __cpuinit void cpu_probe(void)
>  	case PRID_COMP_CAVIUM:
>  		cpu_probe_cavium(c, cpu);
>  		break;
> +	case PRID_COMP_INGENIC:
> +		cpu_probe_ingenic(c, cpu);
> +		break;
>  	}
> 
>  	BUG_ON(!__cpu_name[cpu]);
> diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
> index 86f004d..4510e61 100644
> --- a/arch/mips/mm/tlbex.c
> +++ b/arch/mips/mm/tlbex.c
> @@ -409,6 +409,11 @@ static void __cpuinit build_tlb_write_entry(u32 **p,
> struct uasm_label **l, tlbw(p);
>  		break;
> 
> +	case CPU_JZRISC:
> +		tlbw(p);
> +		uasm_i_nop(p);
> +		break;
> +
>  	default:
>  		panic("No TLB refill handler yet (CPU type: %d)",
>  		      current_cpu_data.cputype);
