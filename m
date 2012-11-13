Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2KMHpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:45:19 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14824 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab2KMHpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:45:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 12 Nov 2012 23:45:09 -0800
Message-ID: <50A1FA7C.4010507@nvidia.com>
Date: Tue, 13 Nov 2012 15:45:00 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 09:20 PM, Thierry Reding wrote:
> This commit adds the host1x node along with its children to the Tegra20
> DTSI. Furthermore the OF auxiliary data table is updated to have proper
> names assigned to the platform devices instantiated from the device
> tree. Moreover, the clocks required by host1x and the two display
> controllers are initialized and the pll_d frequency table is completed
> with a few entries to support common HDMI and LVDS display modes.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  arch/arm/boot/dts/tegra20.dtsi            | 87 +++++++++++++++++++++++++++++++
>  arch/arm/mach-tegra/board-dt-tegra20.c    |  9 ++++
>  arch/arm/mach-tegra/tegra20_clocks_data.c | 23 ++++----
>  3 files changed, 110 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> index 71a650d..2b4dec9 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -4,6 +4,93 @@
>         compatible = "nvidia,tegra20";
>         interrupt-parent = <&intc>;
> 
> +       host1x {
> +               compatible = "nvidia,tegra20-host1x", "simple-bus";
> +               reg = <0x50000000 0x00024000>;
> +               interrupts = <0 65 0x04   /* mpcore syncpt */
> +                             0 67 0x04>; /* mpcore general */
> +
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +
> +               ranges = <0x54000000 0x54000000 0x04000000>;
> +
> +               mpe {
> +                       compatible = "nvidia,tegra20-mpe";
> +                       reg = <0x54040000 0x00040000>;
> +                       interrupts = <0 68 0x04>;
> +               };
> +
> +               vi {
> +                       compatible = "nvidia,tegra20-vi";
> +                       reg = <0x54080000 0x00040000>;
> +                       interrupts = <0 69 0x04>;
> +               };
> +
> +               epp {
> +                       compatible = "nvidia,tegra20-epp";
> +                       reg = <0x540c0000 0x00040000>;
> +                       interrupts = <0 70 0x04>;
> +               };
> +
> +               isp {
> +                       compatible = "nvidia,tegra20-isp";
> +                       reg = <0x54100000 0x00040000>;
> +                       interrupts = <0 71 0x04>;
> +               };
> +
> +               gr2d {
> +                       compatible = "nvidia,tegra20-gr2d";
> +                       reg = <0x54140000 0x00040000>;
> +                       interrupts = <0 72 0x04>;
> +               };
> +
> +               gr3d {
> +                       compatible = "nvidia,tegra20-gr3d";
> +                       reg = <0x54180000 0x00040000>;
> +               };
> +
> +               dc@54200000 {
> +                       compatible = "nvidia,tegra20-dc";
> +                       reg = <0x54200000 0x00040000>;
> +                       interrupts = <0 73 0x04>;
> +
> +                       rgb {
> +                               status = "disabled";
> +                       };
> +               };
> +
> +               dc@54240000 {
> +                       compatible = "nvidia,tegra20-dc";
> +                       reg = <0x54240000 0x00040000>;
> +                       interrupts = <0 74 0x04>;
> +
> +                       rgb {
> +                               status = "disabled";
> +                       };
> +               };
> +
> +               hdmi {
> +                       compatible = "nvidia,tegra20-hdmi";
> +                       reg = <0x54280000 0x00040000>;
> +                       interrupts = <0 75 0x04>;
> +                       status = "disabled";
> +               };
> +
> +               tvo {
> +                       compatible = "nvidia,tegra20-tvo";
> +                       reg = <0x542c0000 0x00040000>;
> +                       interrupts = <0 76 0x04>;
> +                       status = "disabled";
> +               };
> +
> +               dsi {
> +                       compatible = "nvidia,tegra20-dsi";
> +                       reg = <0x54300000 0x00040000>;
> +                       status = "disabled";
> +               };
> +       };
> +
>         timer@50004600 {
>                 compatible = "arm,cortex-a9-twd-timer";
>                 reg = <0x50040600 0x20>;
> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
> index 22f5a9b..1afbdd1 100644
> --- a/arch/arm/mach-tegra/board-dt-tegra20.c
> +++ b/arch/arm/mach-tegra/board-dt-tegra20.c
> @@ -93,6 +93,12 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
>         OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D600, "spi_tegra.1", NULL),
>         OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D800, "spi_tegra.2", NULL),
>         OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000DA00, "spi_tegra.3", NULL),
> +       OF_DEV_AUXDATA("nvidia,tegra20-host1x", 0x50000000, "tegra-host1x", NULL),
> +       OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54200000, "tegra-dc.0", NULL),
> +       OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54240000, "tegra-dc.1", NULL),
> +       OF_DEV_AUXDATA("nvidia,tegra20-hdmi", 0x54280000, "tegra-hdmi", NULL),
> +       OF_DEV_AUXDATA("nvidia,tegra20-dsi", 0x54300000, "tegra-dsi", NULL),
> +       OF_DEV_AUXDATA("nvidia,tegra20-tvo", 0x542c0000, "tegra-tvo", NULL),
>         {}
>  };
> 
> @@ -116,6 +122,9 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
>         { "sbc2",       "pll_p",        100000000,      false },
>         { "sbc3",       "pll_p",        100000000,      false },
>         { "sbc4",       "pll_p",        100000000,      false },
> +       { "host1x",     "pll_c",        144000000,      false },
> +       { "disp1",      "pll_p",        600000000,      false },
> +       { "disp2",      "pll_p",        600000000,      false },

I think here the parent of disp2 should be "pll_d_out0", not "pll_p".
Right now pll_p has not a proper clock setting to make 148.5MHz 1080p
HDMI happy. In addition, you add the 297MHz in pll_d frequency table
next and I think this is for disp2 has a proper clock rate to support HDMI.

>         { NULL,         NULL,           0,              0},
>  };
> 
> diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
> index 9615ee3..2e247f2 100644
> --- a/arch/arm/mach-tegra/tegra20_clocks_data.c
> +++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
> @@ -246,11 +246,16 @@ static struct clk_pll_freq_table tegra_pll_d_freq_table[] = {
>         { 19200000, 216000000, 135, 12, 1, 3},
>         { 26000000, 216000000, 216, 26, 1, 4},
> 
> +       { 12000000, 297000000,  99,  4, 1, 4 },
> +       { 12000000, 339000000, 113,  4, 1, 4 },
> +
>         { 12000000, 594000000, 594, 12, 1, 8},
>         { 13000000, 594000000, 594, 13, 1, 8},
>         { 19200000, 594000000, 495, 16, 1, 8},
>         { 26000000, 594000000, 594, 26, 1, 8},
> 
> +       { 12000000, 616000000, 616, 12, 1, 8},
> +
>         { 12000000, 1000000000, 1000, 12, 1, 12},
>         { 13000000, 1000000000, 1000, 13, 1, 12},
>         { 19200000, 1000000000, 625,  12, 1, 8},
> @@ -930,17 +935,17 @@ PERIPH_CLK(vi,            "tegra_camera",         "vi",   20,     0x148,  150000000, mux_pllm_pllc_pllp_
>  PERIPH_CLK(vi_sensor,  "tegra_camera",         "vi_sensor",    20,     0x1a8,  150000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71 | PERIPH_NO_RESET); /* scales with voltage and process_id */
>  PERIPH_CLK(epp,                "epp",                  NULL,   19,     0x16c,  300000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71); /* scales with voltage and process_id */
>  PERIPH_CLK(mpe,                "mpe",                  NULL,   60,     0x170,  250000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71); /* scales with voltage and process_id */
> -PERIPH_CLK(host1x,     "host1x",               NULL,   28,     0x180,  166000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71); /* scales with voltage and process_id */
> +PERIPH_CLK(host1x,     "tegra-host1x",         NULL,   28,     0x180,  166000000, mux_pllm_pllc_pllp_plla,     MUX | DIV_U71); /* scales with voltage and process_id */
>  PERIPH_CLK(cve,                "cve",                  NULL,   49,     0x140,  250000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
> -PERIPH_CLK(tvo,                "tvo",                  NULL,   49,     0x188,  250000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
> -PERIPH_CLK(hdmi,       "hdmi",                 NULL,   51,     0x18c,  600000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
> +PERIPH_CLK(tvo,                "tegra-tvo",            NULL,   49,     0x188,  250000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
> +PERIPH_CLK(hdmi,       "tegra-hdmi",           NULL,   51,     0x18c,  600000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
>  PERIPH_CLK(tvdac,      "tvdac",                NULL,   53,     0x194,  250000000, mux_pllp_plld_pllc_clkm,     MUX | DIV_U71); /* requires min voltage */
> -PERIPH_CLK(disp1,      "tegradc.0",            NULL,   27,     0x138,  600000000, mux_pllp_plld_pllc_clkm,     MUX); /* scales with voltage and process_id */
> -PERIPH_CLK(disp2,      "tegradc.1",            NULL,   26,     0x13c,  600000000, mux_pllp_plld_pllc_clkm,     MUX); /* scales with voltage and process_id */
> +PERIPH_CLK(disp1,      "tegra-dc.0",           NULL,   27,     0x138,  600000000, mux_pllp_plld_pllc_clkm,     MUX); /* scales with voltage and process_id */
> +PERIPH_CLK(disp2,      "tegra-dc.1",           NULL,   26,     0x13c,  600000000, mux_pllp_plld_pllc_clkm,     MUX); /* scales with voltage and process_id */
>  PERIPH_CLK(usbd,       "fsl-tegra-udc",        NULL,   22,     0,      480000000, mux_clk_m,                   0); /* requires min voltage */
>  PERIPH_CLK(usb2,       "tegra-ehci.1",         NULL,   58,     0,      480000000, mux_clk_m,                   0); /* requires min voltage */
>  PERIPH_CLK(usb3,       "tegra-ehci.2",         NULL,   59,     0,      480000000, mux_clk_m,                   0); /* requires min voltage */
> -PERIPH_CLK(dsi,                "dsi",                  NULL,   48,     0,      500000000, mux_plld,                    0); /* scales with voltage */
> +PERIPH_CLK(dsi,                "tegra-dsi",            NULL,   48,     0,      500000000, mux_plld,                    0); /* scales with voltage */
>  PERIPH_CLK(csi,                "tegra_camera",         "csi",  52,     0,      72000000,  mux_pllp_out3,               0);
>  PERIPH_CLK(isp,                "tegra_camera",         "isp",  23,     0,      150000000, mux_clk_m,                   0); /* same frequency as VI */
>  PERIPH_CLK(csus,       "tegra_camera",         "csus", 92,     0,      150000000, mux_clk_m,                   PERIPH_NO_RESET);
> @@ -1036,9 +1041,6 @@ static struct clk_duplicate tegra_clk_duplicates[] = {
>         CLK_DUPLICATE("usbd",   "utmip-pad",    NULL),
>         CLK_DUPLICATE("usbd",   "tegra-ehci.0", NULL),
>         CLK_DUPLICATE("usbd",   "tegra-otg",    NULL),
> -       CLK_DUPLICATE("hdmi",   "tegradc.0",    "hdmi"),
> -       CLK_DUPLICATE("hdmi",   "tegradc.1",    "hdmi"),
> -       CLK_DUPLICATE("host1x", "tegra_grhost", "host1x"),
>         CLK_DUPLICATE("2d",     "tegra_grhost", "gr2d"),
>         CLK_DUPLICATE("3d",     "tegra_grhost", "gr3d"),
>         CLK_DUPLICATE("epp",    "tegra_grhost", "epp"),
> @@ -1051,6 +1053,9 @@ static struct clk_duplicate tegra_clk_duplicates[] = {
>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.1", "fast-clk"),
>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
>         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
> +       CLK_DUPLICATE("pll_p", "tegra-dc.0", "parent"),
> +       CLK_DUPLICATE("pll_p", "tegra-dc.1", "parent"),
> +       CLK_DUPLICATE("pll_d_out0", "tegra-hdmi", "parent"),
>  };

The same with my above comments, the tegra-dc.1's parent should be
pll_d_out0.

> 
>  #define CLK(dev, con, ck)      \
> --
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
