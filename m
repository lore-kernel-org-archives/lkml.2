Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2IZRwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:52:02 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60962 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab2IZRwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <1348194419-11486-8-git-send-email-sboyd@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
	<1348194419-11486-8-git-send-email-sboyd@codeaurora.org>
Date: Wed, 26 Sep 2012 23:21:59 +0530
Message-ID: <CADTbHxqrPmnOHqqYyskC32bN269k-_pgk-+czwf7zLCs70ESzA@mail.gmail.com>
Subject: Re: [PATCH 07/10] ARM: msm: Remove clock-7x30.h include file
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Sep 21, 2012 at 7:56 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> This file is not used outside of the two users in the clock-7x30
> array. Those two clocks are virtual "source" clocks that don't
> really need to exist outside of the clock driver. Let's remove
> them from the array, since they're not doing anything anyway, and
> then remove the clock-7x30.h include file along with it.
>
> Cc: Saravana Kannan <skannan@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/clock-7x30.h      | 155 ------------------------------------
>  arch/arm/mach-msm/devices-msm7x30.c |   2 -
>  2 files changed, 157 deletions(-)
>  delete mode 100644 arch/arm/mach-msm/clock-7x30.h
>
> diff --git a/arch/arm/mach-msm/clock-7x30.h b/arch/arm/mach-msm/clock-7x30.h
> deleted file mode 100644
> index 1410445..0000000
> --- a/arch/arm/mach-msm/clock-7x30.h
> +++ /dev/null
> @@ -1,155 +0,0 @@
> -/* Copyright (c) 2009, Code Aurora Forum. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 and
> - * only version 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#ifndef __ARCH_ARM_MACH_MSM_CLOCK_7X30_H
> -#define __ARCH_ARM_MACH_MSM_CLOCK_7X30_H
> -
> -enum {
> -       L_7X30_NONE_CLK = -1,
> -       L_7X30_ADM_CLK,
> -       L_7X30_I2C_CLK,
> -       L_7X30_I2C_2_CLK,
> -       L_7X30_QUP_I2C_CLK,
> -       L_7X30_UART1DM_CLK,
> -       L_7X30_UART1DM_P_CLK,
> -       L_7X30_UART2DM_CLK,
> -       L_7X30_UART2DM_P_CLK,
> -       L_7X30_EMDH_CLK,
> -       L_7X30_EMDH_P_CLK,
> -       L_7X30_PMDH_CLK,
> -       L_7X30_PMDH_P_CLK,
> -       L_7X30_GRP_2D_CLK,
> -       L_7X30_GRP_2D_P_CLK,
> -       L_7X30_GRP_3D_SRC_CLK,
> -       L_7X30_GRP_3D_CLK,
> -       L_7X30_GRP_3D_P_CLK,
> -       L_7X30_IMEM_CLK,
> -       L_7X30_SDC1_CLK,
> -       L_7X30_SDC1_P_CLK,
> -       L_7X30_SDC2_CLK,
> -       L_7X30_SDC2_P_CLK,
> -       L_7X30_SDC3_CLK,
> -       L_7X30_SDC3_P_CLK,
> -       L_7X30_SDC4_CLK,
> -       L_7X30_SDC4_P_CLK,
> -       L_7X30_MDP_CLK,
> -       L_7X30_MDP_P_CLK,
> -       L_7X30_MDP_LCDC_PCLK_CLK,
> -       L_7X30_MDP_LCDC_PAD_PCLK_CLK,
> -       L_7X30_MDP_VSYNC_CLK,
> -       L_7X30_MI2S_CODEC_RX_M_CLK,
> -       L_7X30_MI2S_CODEC_RX_S_CLK,
> -       L_7X30_MI2S_CODEC_TX_M_CLK,
> -       L_7X30_MI2S_CODEC_TX_S_CLK,
> -       L_7X30_MI2S_M_CLK,
> -       L_7X30_MI2S_S_CLK,
> -       L_7X30_LPA_CODEC_CLK,
> -       L_7X30_LPA_CORE_CLK,
> -       L_7X30_LPA_P_CLK,
> -       L_7X30_MIDI_CLK,
> -       L_7X30_MDC_CLK,
> -       L_7X30_ROTATOR_IMEM_CLK,
> -       L_7X30_ROTATOR_P_CLK,
> -       L_7X30_SDAC_M_CLK,
> -       L_7X30_SDAC_CLK,
> -       L_7X30_UART1_CLK,
> -       L_7X30_UART2_CLK,
> -       L_7X30_UART3_CLK,
> -       L_7X30_TV_CLK,
> -       L_7X30_TV_DAC_CLK,
> -       L_7X30_TV_ENC_CLK,
> -       L_7X30_HDMI_CLK,
> -       L_7X30_TSIF_REF_CLK,
> -       L_7X30_TSIF_P_CLK,
> -       L_7X30_USB_HS_SRC_CLK,
> -       L_7X30_USB_HS_CLK,
> -       L_7X30_USB_HS_CORE_CLK,
> -       L_7X30_USB_HS_P_CLK,
> -       L_7X30_USB_HS2_CLK,
> -       L_7X30_USB_HS2_CORE_CLK,
> -       L_7X30_USB_HS2_P_CLK,
> -       L_7X30_USB_HS3_CLK,
> -       L_7X30_USB_HS3_CORE_CLK,
> -       L_7X30_USB_HS3_P_CLK,
> -       L_7X30_VFE_CLK,
> -       L_7X30_VFE_P_CLK,
> -       L_7X30_VFE_MDC_CLK,
> -       L_7X30_VFE_CAMIF_CLK,
> -       L_7X30_CAMIF_PAD_P_CLK,
> -       L_7X30_CAM_M_CLK,
> -       L_7X30_JPEG_CLK,
> -       L_7X30_JPEG_P_CLK,
> -       L_7X30_VPE_CLK,
> -       L_7X30_MFC_CLK,
> -       L_7X30_MFC_DIV2_CLK,
> -       L_7X30_MFC_P_CLK,
> -       L_7X30_SPI_CLK,
> -       L_7X30_SPI_P_CLK,
> -       L_7X30_CSI0_CLK,
> -       L_7X30_CSI0_VFE_CLK,
> -       L_7X30_CSI0_P_CLK,
> -       L_7X30_CSI1_CLK,
> -       L_7X30_CSI1_VFE_CLK,
> -       L_7X30_CSI1_P_CLK,
> -       L_7X30_GLBL_ROOT_CLK,
> -
> -       L_7X30_AXI_LI_VG_CLK,
> -       L_7X30_AXI_LI_GRP_CLK,
> -       L_7X30_AXI_LI_JPEG_CLK,
> -       L_7X30_AXI_GRP_2D_CLK,
> -       L_7X30_AXI_MFC_CLK,
> -       L_7X30_AXI_VPE_CLK,
> -       L_7X30_AXI_LI_VFE_CLK,
> -       L_7X30_AXI_LI_APPS_CLK,
> -       L_7X30_AXI_MDP_CLK,
> -       L_7X30_AXI_IMEM_CLK,
> -       L_7X30_AXI_LI_ADSP_A_CLK,
> -       L_7X30_AXI_ROTATOR_CLK,
> -
> -       L_7X30_NR_CLKS
> -};
> -
> -struct clk_ops;
> -extern struct clk_ops clk_ops_7x30;
> -
> -struct clk_ops *clk_7x30_is_local(uint32_t id);
> -int clk_7x30_init(void);
> -
> -void pll_enable(uint32_t pll);
> -void pll_disable(uint32_t pll);
> -
> -extern int internal_pwr_rail_ctl_auto(unsigned rail_id, bool enable);
> -
> -#define CLK_7X30(clk_name, clk_id, clk_dev, clk_flags) {       \
> -       .con_id = clk_name, \
> -       .dev_id = clk_dev, \
> -       .clk = &(struct clk){ \
> -               .id = L_7X30_##clk_id, \
> -               .remote_id = P_##clk_id, \
> -               .flags = clk_flags, \
> -               .dbg_name = #clk_id, \
> -       }, \
> -       }
> -
> -#define CLK_7X30S(clk_name, l_id, r_id, clk_dev, clk_flags) {  \
> -       .con_id = clk_name, \
> -       .dev_id = clk_dev, \
> -       .clk = &(struct clk){ \
> -               .id = L_7X30_##l_id, \
> -               .remote_id = P_##r_id, \
> -               .flags = clk_flags, \
> -               .dbg_name = #l_id, \
> -               .ops = &clk_ops_pcom, \
> -       }, \
> -       }
> -
> -#endif
> diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
> index 09b4f14..1597d43 100644
> --- a/arch/arm/mach-msm/devices-msm7x30.c
> +++ b/arch/arm/mach-msm/devices-msm7x30.c
> @@ -146,7 +146,6 @@ struct clk_lookup msm_clocks_7x30[] = {
>         CLK_PCOM("grp_2d_pclk", GRP_2D_P_CLK,   NULL, 0),
>         CLK_PCOM("grp_clk",     GRP_3D_CLK,     NULL, 0),
>         CLK_PCOM("grp_pclk",    GRP_3D_P_CLK,   NULL, 0),
> -       CLK_7X30S("grp_src_clk", GRP_3D_SRC_CLK, GRP_3D_CLK,    NULL, 0),
>         CLK_PCOM("hdmi_clk",    HDMI_CLK,       NULL, 0),
>         CLK_PCOM("imem_clk",    IMEM_CLK,       NULL, OFF),
I suppose you forget to remove the include header clock-7x30.h from
this file. :)

--
Pankaj Kumar
