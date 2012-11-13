Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2KMEhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 23:37:31 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5107 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab2KMEha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 23:37:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 12 Nov 2012 20:37:23 -0800
Message-ID: <50A1CE7E.2060707@nvidia.com>
Date: Tue, 13 Nov 2012 12:37:18 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: tegra: Add Tegra30 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-3-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352467202-27903-3-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 09:20 PM, Thierry Reding wrote:
> This commit adds the host1x node along with its children to the Tegra30
> DTSI. Furthermore the OF auxiliary data table is updated to have proper
> names assigned to the platform devices instantiated from the device
> tree. Moreover, the clocks required by host1x and the two display
> controllers are setup and initialized.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  arch/arm/boot/dts/tegra30.dtsi            | 87 +++++++++++++++++++++++++++++++
>  arch/arm/mach-tegra/board-dt-tegra30.c    | 10 ++++
>  arch/arm/mach-tegra/tegra30_clocks_data.c | 11 ++--
>  3 files changed, 104 insertions(+), 4 deletions(-)
> 
...
> 
> diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
> index 7bc8b1d..210b8a4 100644
> --- a/arch/arm/mach-tegra/tegra30_clocks_data.c
> +++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
> @@ -1132,14 +1132,14 @@ PERIPH_CLK(2d,          "2d",                   NULL,   21,     0x15c,  520000000, mux_pllm_pllc_pllp_plla,     MUX
>  PERIPH_CLK(vi_sensor,  "tegra_camera",         "vi_sensor",    20,     0x1a8,  150000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71 | PERIPH_NO_RESET);
>  PERIPH_CLK(epp,                "epp",                  NULL,   19,     0x16c,  520000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71 | DIV_U71_INT);
>  PERIPH_CLK(mpe,                "mpe",                  NULL,   60,     0x170,  520000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71 | DIV_U71_INT);
> -PERIPH_CLK(host1x,     "host1x",               NULL,   28,     0x180,  260000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71 | DIV_U71_INT);
> +PERIPH_CLK(host1x,     "tegra-host1x",         NULL,   28,     0x180,  260000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71 | DIV_U71_INT);
>  PERIPH_CLK(cve,                "cve",                  NULL,   49,     0x140,  250000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
>  PERIPH_CLK(tvo,                "tvo",                  NULL,   49,     0x188,  250000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
>  PERIPH_CLK(dtv,                "dtv",                  NULL,   79,     0x1dc,  250000000, mux_clk_m,                   0);
> -PERIPH_CLK(hdmi,       "hdmi",                 NULL,   51,     0x18c,  148500000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,     MUX | MUX8 | DIV_U71);
> +PERIPH_CLK(hdmi,       "tegra-hdmi",                   NULL,   51,     0x18c,  148500000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,     MUX | MUX8 | DIV_U71);
>  PERIPH_CLK(tvdac,      "tvdac",                NULL,   53,     0x194,  220000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
> -PERIPH_CLK(disp1,      "tegradc.0",            NULL,   27,     0x138,  600000000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,     MUX | MUX8);
> -PERIPH_CLK(disp2,      "tegradc.1",            NULL,   26,     0x13c,  600000000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,     MUX | MUX8);
> +PERIPH_CLK(disp1,      "tegra-dc.0",           NULL,   27,     0x138,  600000000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,     MUX | MUX8);
> +PERIPH_CLK(disp2,      "tegra-dc.1",           NULL,   26,     0x13c,  600000000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,     MUX | MUX8);
>  PERIPH_CLK(usbd,       "fsl-tegra-udc",        NULL,   22,     0,      480000000, mux_clk_m,                   0); /* requires min voltage */
>  PERIPH_CLK(usb2,       "tegra-ehci.1",         NULL,   58,     0,      480000000, mux_clk_m,                   0); /* requires min voltage */
>  PERIPH_CLK(usb3,       "tegra-ehci.2",         NULL,   59,     0,      480000000, mux_clk_m,                   0); /* requires min voltage */
> @@ -1337,6 +1337,9 @@ struct clk_duplicate tegra_clk_duplicates[] = {
>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.4", "fast-clk"),
> +       CLK_DUPLICATE("pll_p", "tegra-dc.0", "parent"),
> +       CLK_DUPLICATE("pll_p", "tegra-dc.1", "parent"),
> +       CLK_DUPLICATE("pll_d2_out0", "tegra-hdmi", "parent"),
>  };

Why we need this? Set the parent of "tegra-dc.0" & "tegra-dc.1" to "pll_p"?

Mark
> 
>  struct clk *tegra_ptr_clks[] = {
> --
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
