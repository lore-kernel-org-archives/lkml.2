Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0KIVqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:46:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45224 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0KIVqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:46:10 -0500
Date: Tue, 9 Nov 2010 22:46:07 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        amit.kucheria@canonical.com, eric@eukrea.com
Subject: Re: [PATCHv3 1/2] ARM: imx: Add core definitions for MX53
Message-ID: <20101109214607.GG6017@pengutronix.de>
References: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:14:03 up 129 days, 12:24, 23 users,  load average: 0.26, 0.26,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Fri, Nov 05, 2010 at 10:55:50AM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add iomux, clocks,  and memory map for Freescale's MX53 SoC.
> Add cpu_is_mx53 function to common.h.
> Add 3 more banks of gpio's to mxc_gpio_ports.
> Add MX53 phys offset address.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/clock-mx53.c              |  857 +++++++++++++++++++++++++++
>  arch/arm/mach-mx5/devices.c                 |   27 +
>  arch/arm/plat-mxc/include/mach/common.h     |    4 +
>  arch/arm/plat-mxc/include/mach/iomux-mx53.h |  303 ++++++++++
>  arch/arm/plat-mxc/include/mach/memory.h     |    1 +
>  arch/arm/plat-mxc/include/mach/mx53.h       |  406 +++++++++++++
>  6 files changed, 1598 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/clock-mx53.c
>  create mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx53.h
>  create mode 100644 arch/arm/plat-mxc/include/mach/mx53.h
> 
> diff --git a/arch/arm/mach-mx5/clock-mx53.c b/arch/arm/mach-mx5/clock-mx53.c
> new file mode 100644
> index 0000000..d547cb8
> --- /dev/null
> +++ b/arch/arm/mach-mx5/clock-mx53.c

Most of this code looks like it could be shared with clock-mx51.c

> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
> index 4c7be87..99aa13d 100644
> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -160,9 +160,36 @@ static struct mxc_gpio_port mxc_gpio_ports[] = {
>  		.irq_high = MX51_MXC_INT_GPIO4_HIGH,
>  		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3
>  	},
> +	{
> +		.chip.label = "gpio-4",
> +		.base = MX53_IO_ADDRESS(MX53_GPIO5_BASE_ADDR),
> +		.irq = MX53_MXC_INT_GPIO5_LOW,
> +		.irq_high = MX53_MXC_INT_GPIO5_HIGH,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3

MXC_GPIO_IRQ_START + 32 * 4

> +	},
> +	{
> +		.chip.label = "gpio-5",
> +		.base = MX53_IO_ADDRESS(MX53_GPIO6_BASE_ADDR),
> +		.irq = MX53_MXC_INT_GPIO6_LOW,
> +		.irq_high = MX53_MXC_INT_GPIO6_HIGH,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3

MXC_GPIO_IRQ_START + 32 * 5

> +	},
> +	{
> +		.chip.label = "gpio-6",
> +		.base = MX53_IO_ADDRESS(MX53_GPIO7_BASE_ADDR),
> +		.irq = MX53_MXC_INT_GPIO7_LOW,
> +		.irq_high = MX53_MXC_INT_GPIO7_HIGH,
> +		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3

MXC_GPIO_IRQ_START + 32 * 6

> +	},
>  };
>  
>  int __init imx51_register_gpios(void)
>  {
> +	return mxc_gpio_init(mxc_gpio_ports, 4);
> +}
> +
> +int __init imx53_register_gpios(void)
> +{
>  	return mxc_gpio_init(mxc_gpio_ports, ARRAY_SIZE(mxc_gpio_ports));
>  }
> +
> diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
> index 7a1e1f8..2919052 100644
> --- a/arch/arm/plat-mxc/include/mach/common.h
> +++ b/arch/arm/plat-mxc/include/mach/common.h
> @@ -21,6 +21,7 @@ extern void mx27_map_io(void);
>  extern void mx31_map_io(void);
>  extern void mx35_map_io(void);
>  extern void mx51_map_io(void);
> +extern void mx53_map_io(void);
>  extern void mxc91231_map_io(void);
>  extern void mxc_init_irq(void __iomem *);
>  extern void tzic_init_irq(void __iomem *);
> @@ -31,6 +32,7 @@ extern void mx27_init_irq(void);
>  extern void mx31_init_irq(void);
>  extern void mx35_init_irq(void);
>  extern void mx51_init_irq(void);
> +extern void mx53_init_irq(void);
>  extern void mxc91231_init_irq(void);
>  extern void epit_timer_init(struct clk *timer_clk, void __iomem *base, int irq);
>  extern void mxc_timer_init(struct clk *timer_clk, void __iomem *, int);
> @@ -42,6 +44,8 @@ extern int mx31_clocks_init(unsigned long fref);
>  extern int mx35_clocks_init(void);
>  extern int mx51_clocks_init(unsigned long ckil, unsigned long osc,
>  			unsigned long ckih1, unsigned long ckih2);
> +extern int mx53_clocks_init(unsigned long ckil, unsigned long osc,
> +			unsigned long ckih1, unsigned long ckih2);
>  extern int mxc91231_clocks_init(unsigned long fref);
>  extern int mxc_register_gpios(void);
>  extern int mxc_register_device(struct platform_device *pdev, void *data);

...

> diff --git a/arch/arm/plat-mxc/include/mach/mx53.h b/arch/arm/plat-mxc/include/mach/mx53.h
> new file mode 100644
> index 0000000..51714fa
> --- /dev/null
> +++ b/arch/arm/plat-mxc/include/mach/mx53.h
> @@ -0,0 +1,406 @@
> +#ifndef __MACH_MX53_H__
> +#define __MACH_MX53_H__
> +
> +/*
> + * IROM
> + */
> +#define MX53_IROM_BASE_ADDR		0x0
> +#define MX53_IROM_SIZE			SZ_64K
> +
> +/* TZIC */
> +#define MX53_TZIC_BASE_ADDR		0x0FFFC000
> +
> +/*
> + * AHCI SATA
> + */
> +#define MX53_SATA_BASE_ADDR 		0x10000000
> +
> +/*
> + * NFC
> + */
> +#define MX53_NFC_BASE_ADDR_AXI	0xF7FF0000	/* NAND flash AXI */
> +#define MX53_NFC_AXI_SIZE		SZ_64K
> +
> +/*
> + * IRAM
> + */
> +#define MX53_IRAM_BASE_ADDR	0xF8000000	/* internal ram */
> +#define MX53_IRAM_PARTITIONS	16
> +#define MX53_IRAM_SIZE		(IRAM_PARTITIONS * SZ_8K)	/* 128KB */
> +
> +/*
> + * Graphics Memory of GPU
> + */
> +#define MX53_IPU_CTRL_BASE_ADDR		0x18000000
> +#define MX53_GPU2D_BASE_ADDR		0x20000000
> +#define MX53_GPU_BASE_ADDR		0x30000000
> +#define MX53_GPU_GMEM_BASE_ADDR	0xF8020000
> +
> +#define MX53_DEBUG_BASE_ADDR		0x40000000
> +#define MX53_DEBUG_BASE_ADDR_VIRT	0xFA200000
> +#define MX53_DEBUG_SIZE			SZ_1M
> +#define MX53_ETB_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00001000)
> +#define MX53_ETM_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00002000)
> +#define MX53_TPIU_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00003000)
> +#define MX53_CTI0_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00004000)
> +#define MX53_CTI1_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00005000)
> +#define MX53_CTI2_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00006000)
> +#define MX53_CTI3_BASE_ADDR		(DEBUG_BASE_ADDR + 0x00007000)
> +#define MX53_CORTEX_DBG_BASE_ADDR	(DEBUG_BASE_ADDR + 0x00008000)

Shouldn't these be MX53_DEBUG_BASE_ADDR + x?

> +
> +/*
> + * SPBA global module enabled #0
> + */
> +#define MX53_SPBA0_BASE_ADDR 		0x50000000
> +#define MX53_SPBA0_BASE_ADDR_VIRT	0xFB100000
> +#define MX53_SPBA0_SIZE			SZ_1M
> +
> +#define MX53_MMC_SDHC1_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00004000)
> +#define MX53_MMC_SDHC2_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00008000)
> +#define MX53_UART3_BASE_ADDR 		(SPBA0_BASE_ADDR + 0x0000C000)
> +#define MX53_CSPI1_BASE_ADDR 		(SPBA0_BASE_ADDR + 0x00010000)
> +#define MX53_SSI2_BASE_ADDR		(SPBA0_BASE_ADDR + 0x00014000)
> +#define MX53_MMC_SDHC3_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00020000)
> +#define MX53_MMC_SDHC4_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00024000)
> +#define MX53_SPDIF_BASE_ADDR		(SPBA0_BASE_ADDR + 0x00028000)
> +#define MX53_ASRC_BASE_ADDR		(SPBA0_BASE_ADDR + 0x0002C000)
> +#define MX53_ATA_DMA_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00030000)
> +#define MX53_SLIM_DMA_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00034000)
> +#define MX53_HSI2C_DMA_BASE_ADDR	(SPBA0_BASE_ADDR + 0x00038000)
> +#define MX53_SPBA_CTRL_BASE_ADDR	(SPBA0_BASE_ADDR + 0x0003C000)

MX53_SPBA_BASE_ADDR + x

> +
> +/*
> + * AIPS 1
> + */
> +#define MX53_AIPS1_BASE_ADDR 	0x53F00000
> +#define MX53_AIPS1_BASE_ADDR_VIRT	0xFB000000
> +#define MX53_AIPS1_SIZE		SZ_1M
> +
> +#define MX53_OTG_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00080000)
> +#define MX53_GPIO1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00084000)
> +#define MX53_GPIO2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00088000)
> +#define MX53_GPIO3_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x0008C000)
> +#define MX53_GPIO4_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00090000)
> +#define MX53_KPP_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00094000)
> +#define MX53_WDOG_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x00098000)
> +#define MX53_WDOG2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x0009C000)
> +#define MX53_GPT1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000A0000)
> +#define MX53_SRTC_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000A4000)
> +#define MX53_IOMUXC_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000A8000)
> +#define MX53_EPIT1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000AC000)
> +#define MX53_EPIT2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000B0000)
> +#define MX53_PWM1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000B4000)
> +#define MX53_PWM2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000B8000)
> +#define MX53_UART1_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000BC000)
> +#define MX53_UART2_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000C0000)
> +#define MX53_SRC_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000D0000)
> +#define MX53_CCM_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000D4000)
> +#define MX53_GPC_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000D8000)
> +#define MX53_GPIO5_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000DC000)
> +#define MX53_GPIO6_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000E0000)
> +#define MX53_GPIO7_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000E4000)
> +#define MX53_ATA_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000E8000)
> +#define MX53_I2C3_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000EC000)
> +#define MX53_UART4_BASE_ADDR	(MX53_AIPS1_BASE_ADDR + 0x000F0000)
> +
> +/*
> + * AIPS 2
> + */
> +#define MX53_AIPS2_BASE_ADDR		0x63F00000
> +#define MX53_AIPS2_BASE_ADDR_VIRT	0xFB200000
> +#define MX53_AIPS2_SIZE			SZ_1M
> +
> +#define MX53_PLL1_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00080000)
> +#define MX53_PLL2_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00084000)
> +#define MX53_PLL3_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00088000)
> +#define MX53_PLL4_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x0008C000)
> +#define MX53_UART5_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00090000)
> +#define MX53_AHBMAX_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00094000)
> +#define MX53_IIM_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x00098000)
> +#define MX53_CSU_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x0009C000)
> +#define MX53_ARM_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000A0000)
> +#define MX53_OWIRE_BASE_ADDR 	(MX53_AIPS2_BASE_ADDR + 0x000A4000)
> +#define MX53_FIRI_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000A8000)
> +#define MX53_CSPI2_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000AC000)
> +#define MX53_SDMA_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000B0000)
> +#define MX53_SCC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000B4000)
> +#define MX53_ROMCP_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000B8000)
> +#define MX53_RTIC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000BC000)
> +#define MX53_CSPI3_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000C0000)
> +#define MX53_I2C2_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000C4000)
> +#define MX53_I2C1_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000C8000)
> +#define MX53_SSI1_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000CC000)
> +#define MX53_AUDMUX_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000D0000)
> +#define MX53_RTC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000D4000)
> +#define MX53_M4IF_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000D8000)
> +#define MX53_ESDCTL_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000D9000)
> +#define MX53_WEIM_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000DA000)
> +#define MX53_NFC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000DB000)
> +#define MX53_EMI_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000DBF00)
> +#define MX53_MIPI_HSC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000DC000)
> +#define MX53_MLB_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000E4000)
> +#define MX53_SSI3_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000E8000)
> +#define MX53_MXC_FEC_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000EC000)
> +#define MX53_TVE_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000F0000)
> +#define MX53_VPU_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000F4000)
> +#define MX53_SAHARA_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000F8000)
> +#define MX53_PTP_BASE_ADDR	(MX53_AIPS2_BASE_ADDR + 0x000FC000)
> +
> +/*
> + * Memory regions and CS
> + */
> +#define MX53_CSD0_BASE_ADDR		0x90000000
> +#define MX53_CSD1_BASE_ADDR		0xA0000000
> +#define MX53_CS0_BASE_ADDR		0xB0000000
> +#define MX53_CS1_BASE_ADDR		0xB8000000
> +#define MX53_CS2_BASE_ADDR		0xC0000000
> +#define MX53_CS3_BASE_ADDR		0xC8000000
> +#define MX53_CS4_BASE_ADDR		0xCC000000
> +#define MX53_CS5_BASE_ADDR		0xCE000000
> +
> +#define MX53_IO_ADDRESS(x) (						\
> +	IMX_IO_ADDRESS(x, MX53_SPBA0) ?:				\
> +	IMX_IO_ADDRESS(x, MX53_AIPS1) ?:				\
> +	IMX_IO_ADDRESS(x, MX53_AIPS2))
> +
> +/* This is currently used in <mach/debug-macro.S>, but should go away */
> +#define MX53_AIPS1_IO_ADDRESS(x)  \
> +	(((x) - MX53_AIPS1_BASE_ADDR) + MX53_AIPS1_BASE_ADDR_VIRT)

This is not used anymore in imx-for-2.6.38. Please remove.

> +
> +/*
> + * defines for SPBA modules
> + */
> +#define MX53_SPBA_SDHC1	0x04
> +#define MX53_SPBA_SDHC2	0x08
> +#define MX53_SPBA_UART3	0x0C
> +#define MX53_SPBA_CSPI1	0x10
> +#define MX53_SPBA_SSI2	0x14
> +#define MX53_SPBA_SDHC3	0x20
> +#define MX53_SPBA_SDHC4	0x24
> +#define MX53_SPBA_SPDIF	0x28
> +#define MX53_SPBA_ATA	0x30
> +#define MX53_SPBA_SLIM	0x34
> +#define MX53_SPBA_HSI2C	0x38
> +#define MX53_SPBA_CTRL	0x3C
> +
> +/*
> + * Defines for modules using static and dynamic DMA channels
> + */
> +#define MX53_MXC_DMA_CHANNEL_IRAM	30
> +#define MX53_MXC_DMA_CHANNEL_SPDIF_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_UART1_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_UART1_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_UART2_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_UART2_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_UART3_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_UART3_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_MMC1	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_MMC2	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_SSI1_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_SSI1_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_SSI2_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#ifdef CONFIG_SDMA_IRAM
> +#define MX53_MXC_DMA_CHANNEL_SSI2_TX	(MXC_DMA_CHANNEL_IRAM + 1)
> +#else				/*CONFIG_SDMA_IRAM */
> +#define MX53_MXC_DMA_CHANNEL_SSI2_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#endif				/*CONFIG_SDMA_IRAM */
> +#define MX53_MXC_DMA_CHANNEL_CSPI1_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_CSPI1_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_CSPI2_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_CSPI2_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_CSPI3_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_CSPI3_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_ATA_RX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_ATA_TX	MXC_DMA_DYNAMIC_CHANNEL
> +#define MX53_MXC_DMA_CHANNEL_MEMORY	MXC_DMA_DYNAMIC_CHANNEL

These don't look useful for the current SDMA driver implementation.

> +
> +#define MX53_IS_MEM_DEVICE_NONSHARED(x)		0

Do we need this?

> +
> +/*
> + * DMA request assignments
> + */
> +#define MX53_DMA_REQ_SSI3_TX1		47
> +#define MX53_DMA_REQ_SSI3_RX1		46
> +#define MX53_DMA_REQ_SSI3_TX2		45
> +#define MX53_DMA_REQ_SSI3_RX2		44
> +#define MX53_DMA_REQ_UART3_TX	43
> +#define MX53_DMA_REQ_UART3_RX	42
> +#define MX53_DMA_REQ_ESAI_TX		41
> +#define MX53_DMA_REQ_ESAI_RX	40
> +#define MX53_DMA_REQ_CSPI_TX	39
> +#define MX53_DMA_REQ_CSPI_RX	38
> +#define MX53_DMA_REQ_ASRC_DMA6	37
> +#define MX53_DMA_REQ_ASRC_DMA5	36
> +#define MX53_DMA_REQ_ASRC_DMA4	35
> +#define MX53_DMA_REQ_ASRC_DMA3	34
> +#define MX53_DMA_REQ_ASRC_DMA2	33
> +#define MX53_DMA_REQ_ASRC_DMA1	32
> +#define MX53_DMA_REQ_EMI_WR	31
> +#define MX53_DMA_REQ_EMI_RD	30
> +#define MX53_DMA_REQ_SSI1_TX1	29
> +#define MX53_DMA_REQ_SSI1_RX1	28
> +#define MX53_DMA_REQ_SSI1_TX2	27
> +#define MX53_DMA_REQ_SSI1_RX2	26
> +#define MX53_DMA_REQ_SSI2_TX1	25
> +#define MX53_DMA_REQ_SSI2_RX1	24
> +#define MX53_DMA_REQ_SSI2_TX2	23
> +#define MX53_DMA_REQ_SSI2_RX2	22
> +/* I2C2 is shared w/SDHC2 on MX53 */
> +#define MX53_DMA_REQ_SDHC2	21

Then this define should be MX53_DMA_REQ_I2C2_SDHC2, similar for the
other shared dma requests.

> +/* I2C1 is shared w/SDHC1 on MX53 */
> +#define MX53_DMA_REQ_SDHC1	20
> +#define MX53_DMA_REQ_UART1_TX	19
> +#define MX53_DMA_REQ_UART1_RX	18
> +#define MX53_DMA_REQ_UART5_TX	17
> +#define MX53_DMA_REQ_UART5_RX	16
> +#define MX53_DMA_REQ_SPDIF_TX		15
> +#define MX53_DMA_REQ_SPDIF_RX		14
> +/* UART2 is shared w/FIRI on MX53 */
> +#define MX53_DMA_REQ_FIRI_TX	13
> +#define MX53_DMA_REQ_FIRI_RX	12
> +#define MX53_DMA_REQ_SDHC4		11
> +/* SDHC3 is shared w/I2C3 on MX53 */
> +#define MX53_DMA_REQ_I2C3		10
> +#define MX53_DMA_REQ_CSPI2_TX	9
> +#define MX53_DMA_REQ_CSPI2_RX	8
> +#define MX53_DMA_REQ_CSPI1_TX	7
> +#define MX53_DMA_REQ_CSPI1_RX	6
> +#define MX53_DMA_REQ_IPU	5
> +#define MX53_DMA_REQ_ATA_TX_END	4
> +/* UART4 is shared w/PATA on MX53 */
> +#define MX53_DMA_REQ_ATA_TX	3
> +/* UART4 is shared w/PATA on MX53 */
> +#define MX53_DMA_REQ_ATA_RX	2
> +#define MX53_DMA_REQ_GPC	1
> +#define MX53_DMA_REQ_VPU	0
> +
> +/*
> + * Interrupt numbers
> + */
> +#define MX53_MXC_INT_RESV0	0
> +#define MX53_MXC_INT_MMC_SDHC1	1
> +#define MX53_MXC_INT_MMC_SDHC2	2
> +#define MX53_MXC_INT_MMC_SDHC3	3
> +#define MX53_MXC_INT_MMC_SDHC4	4
> +#define MX53_MXC_INT_RESV5	5
> +#define MX53_MXC_INT_SDMA	6
> +#define MX53_MXC_INT_IOMUX	7
> +#define MX53_MXC_INT_NFC	8
> +#define MX53_MXC_INT_VPU	9
> +#define MX53_MXC_INT_IPU_ERR	10
> +#define MX53_MXC_INT_IPU_SYN	11
> +#define MX53_MXC_INT_GPU	12
> +#define MX53_MXC_INT_RESV13	13
> +#define MX53_MXC_INT_USB_H1	14
> +#define MX53_MXC_INT_EMI	15
> +#define MX53_MXC_INT_USB_H2	16
> +#define MX53_MXC_INT_USB_H3	17
> +#define MX53_MXC_INT_USB_OTG	18
> +#define MX53_MXC_INT_SAHARA_H0	19
> +#define MX53_MXC_INT_SAHARA_H1	20
> +#define MX53_MXC_INT_SCC_SMN	21
> +#define MX53_MXC_INT_SCC_STZ	22
> +#define MX53_MXC_INT_SCC_SCM	23
> +#define MX53_MXC_INT_SRTC_NTZ	24
> +#define MX53_MXC_INT_SRTC_TZ	25
> +#define MX53_MXC_INT_RTIC	26
> +#define MX53_MXC_INT_CSU	27
> +#define MX53_MXC_INT_SATA	28
> +#define MX53_MXC_INT_SSI1	29
> +#define MX53_MXC_INT_SSI2	30
> +#define MX53_MXC_INT_UART1	31
> +#define MX53_MXC_INT_UART2	32
> +#define MX53_MXC_INT_UART3	33
> +#define MX53_MXC_INT_RESV34	34
> +#define MX53_MXC_INT_RESV35	35
> +#define MX53_MXC_INT_CSPI1	36
> +#define MX53_MXC_INT_CSPI2	37
> +#define MX53_MXC_INT_CSPI	38
> +#define MX53_MXC_INT_GPT	39
> +#define MX53_MXC_INT_EPIT1	40
> +#define MX53_MXC_INT_EPIT2	41
> +#define MX53_MXC_INT_GPIO1_INT7	42
> +#define MX53_MXC_INT_GPIO1_INT6	43
> +#define MX53_MXC_INT_GPIO1_INT5	44
> +#define MX53_MXC_INT_GPIO1_INT4	45
> +#define MX53_MXC_INT_GPIO1_INT3	46
> +#define MX53_MXC_INT_GPIO1_INT2	47
> +#define MX53_MXC_INT_GPIO1_INT1	48
> +#define MX53_MXC_INT_GPIO1_INT0	49
> +#define MX53_MXC_INT_GPIO1_LOW	50
> +#define MX53_MXC_INT_GPIO1_HIGH	51
> +#define MX53_MXC_INT_GPIO2_LOW	52
> +#define MX53_MXC_INT_GPIO2_HIGH	53
> +#define MX53_MXC_INT_GPIO3_LOW	54
> +#define MX53_MXC_INT_GPIO3_HIGH	55
> +#define MX53_MXC_INT_GPIO4_LOW	56
> +#define MX53_MXC_INT_GPIO4_HIGH	57
> +#define MX53_MXC_INT_WDOG1	58
> +#define MX53_MXC_INT_WDOG2	59
> +#define MX53_MXC_INT_KPP	60
> +#define MX53_MXC_INT_PWM1	61
> +#define MX53_MXC_INT_I2C1	62
> +#define MX53_MXC_INT_I2C2	63
> +#define MX53_MXC_INT_I2C3	64
> +#define MX53_MXC_INT_RESV65	65
> +#define MX53_MXC_INT_RESV66	66
> +#define MX53_MXC_INT_SPDIF	67
> +#define MX53_MXC_INT_SIM_DAT	68
> +#define MX53_MXC_INT_IIM	69
> +#define MX53_MXC_INT_ATA	70
> +#define MX53_MXC_INT_CCM1	71
> +#define MX53_MXC_INT_CCM2	72
> +#define MX53_MXC_INT_GPC1	73
> +#define MX53_MXC_INT_GPC2	74
> +#define MX53_MXC_INT_SRC	75
> +#define MX53_MXC_INT_NM		76
> +#define MX53_MXC_INT_PMU	77
> +#define MX53_MXC_INT_CTI_IRQ	78
> +#define MX53_MXC_INT_CTI1_TG0	79
> +#define MX53_MXC_INT_CTI1_TG1	80
> +#define MX53_MXC_INT_ESAI	81
> +#define MX53_MXC_INT_CAN1	82
> +#define MX53_MXC_INT_CAN2	83
> +#define MX53_MXC_INT_GPU2_IRQ	84
> +#define MX53_MXC_INT_GPU2_BUSY	85
> +#define MX53_MXC_INT_RESV86	86
> +#define MX53_MXC_INT_FEC	87
> +#define MX53_MXC_INT_OWIRE	88
> +#define MX53_MXC_INT_CTI1_TG2	89
> +#define MX53_MXC_INT_SJC	90
> +#define MX53_MXC_INT_TVE	92
> +#define MX53_MXC_INT_FIRI	93
> +#define MX53_MXC_INT_PWM2	94
> +#define MX53_MXC_INT_SLIM_EXP	95
> +#define MX53_MXC_INT_SSI3	96
> +#define MX53_MXC_INT_EMI_BOOT	97
> +#define MX53_MXC_INT_CTI1_TG3	98
> +#define MX53_MXC_INT_SMC_RX	99
> +#define MX53_MXC_INT_VPU_IDLE	100
> +#define MX53_MXC_INT_EMI_NFC	101
> +#define MX53_MXC_INT_GPU_IDLE	102
> +#define MX53_MXC_INT_GPIO5_LOW	103
> +#define MX53_MXC_INT_GPIO5_HIGH	104
> +#define MX53_MXC_INT_GPIO6_LOW	105
> +#define MX53_MXC_INT_GPIO6_HIGH	106
> +#define MX53_MXC_INT_GPIO7_LOW	107
> +#define MX53_MXC_INT_GPIO7_HIGH	108
> +
> +/* silicon revisions specific to i.MX53 */
> +#define MX53_CHIP_REV_1_0		0x10
> +#define MX53_CHIP_REV_1_1		0x11
> +#define MX53_CHIP_REV_1_2		0x12
> +#define MX53_CHIP_REV_1_3		0x13
> +#define MX53_CHIP_REV_2_0		0x20
> +#define MX53_CHIP_REV_2_1		0x21
> +#define MX53_CHIP_REV_2_2		0x22
> +#define MX53_CHIP_REV_2_3		0x23
> +#define MX53_CHIP_REV_3_0		0x30
> +#define MX53_CHIP_REV_3_1		0x31
> +#define MX53_CHIP_REV_3_2		0x32
> +
> +#if !defined(__ASSEMBLY__) && !defined(__MXC_BOOT_UNCOMPRESS)

There is no such define in the kernel. Please remove.

> +extern int mx53_revision(void);
> +#endif
> +
> +#endif	/* ifndef __MACH_H__ */

__MACH_MX53_H__

> -- 
> 1.6.0.4
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
