Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab2DBGuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 02:50:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49314 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DBGt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 02:49:56 -0400
MIME-Version: 1.0
In-Reply-To: <1332440842-1098-5-git-send-email-swarren@wwwdotorg.org>
References: <1332440842-1098-1-git-send-email-swarren@wwwdotorg.org>
	<1332440842-1098-5-git-send-email-swarren@wwwdotorg.org>
Date: Sun, 1 Apr 2012 23:49:55 -0700
X-Google-Sender-Auth: CRst7OyTWoZr_Ql0nTVtDSbgNQg
Message-ID: <CAPnjgZ0KhvPV8oO557i5czebm2J_KF7fmM3RDJoeYRurXu6Prg@mail.gmail.com>
Subject: Re: [PATCH V3 5/6] dt: Document Tegra20/30 pinctrl binding
From: Simon Glass <sjg@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linus.walleij@stericsson.com,
        B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Mar 22, 2012 at 11:27 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> Define a new binding for the Tegra pin controller, which is capable of
> defining all aspects of desired pin multiplexing and pin configuration.
> This is all based on the new common pinctrl bindings.
>
> Add Tegra30 binding based on Tegra20 binding.
>
> Add some basic stuff that was missing before:
> * How many and what reg property entries must be provided.
> * An example.
>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> v3: Fix typo in Tegra20 binding example
> ---
>  .../bindings/pinctrl/nvidia,tegra20-pinmux.txt     |  131 +++++++++++++++++++-
>  .../bindings/pinctrl/nvidia,tegra30-pinmux.txt     |  132 ++++++++++++++++++++
>  2 files changed, 261 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
>
> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
> index 36f82db..c8e5782 100644
> --- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
> @@ -1,5 +1,132 @@
> -NVIDIA Tegra 2 pinmux controller
> +NVIDIA Tegra20 pinmux controller
>
>  Required properties:
> -- compatible : "nvidia,tegra20-pinmux"
> +- compatible: "nvidia,tegra20-pinmux"
> +- reg: Should contain the register physical address and length for each of
> +  the tri-state, mux, pull-up/down, and pad control register sets.
>
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +Tegra's pin configuration nodes act as a container for an abitrary number of
> +subnodes. Each of these subnodes represents some desired configuration for a
> +pin, a group, or a list of pins or groups. This configuration can include the
> +mux function to select on those pin(s)/group(s), and various pin configuration
> +parameters, such as pull-up, tristate, drive strength, etc.
> +
> +The name of each subnode is not important; all subnodes should be enumerated
> +and processed purely based on their content.
> +
> +Each subnode only affects those parameters that are explicitly listed. In
> +other words, a subnode that lists a mux function but no pin configuration
> +parameters implies no information about any pin configuration parameters.
> +Similarly, a pin subnode that describes a pullup parameter implies no
> +information about e.g. the mux function or tristate parameter. For this
> +reason, even seemingly boolean values are actually tristates in this binding:
> +unspecified, off, or on. Unspecified is represented as an absent property,
> +and off/on are represented as integer values 0 and 1.
> +
> +Required subnode-properties:
> +- nvidia,pins : An array of strings. Each string contains the name of a pin or
> +    group. Valid values for these names are listed below.
> +
> +Optional subnode-properties:
> +- nvidia,function: A string containing the name of the function to mux to the
> +  pin or group. Valid values for function names are listed below. See the Tegra
> +  TRM to determine which are valid for each pin or group.
> +- nvidia,pull: Integer, representing the pull-down/up to apply to the pin.
> +    0: none, 1: down, 2: up.
> +- nvidia,tristate: Integer.
> +    0: drive, 1: tristate.
> +- nvidia,high-speed-mode: Integer. Enable high speed mode the pins.
> +    0: no, 1: yes.
> +- nvidia,schmitt: Integer. Enables Schmitt Trigger on the input.
> +    0: no, 1: yes.
> +- nvidia,low-power-mode: Integer. Valid values 0-3. 0 is least power, 3 is
> +    most power. Controls the drive power or current. See "Low Power Mode"
> +    or "LPMD1" and "LPMD0" in the Tegra TRM.
> +- nvidia,pull-down-strength: Integer. Controls drive strength. 0 is weakest.
> +    The range of valid values depends on the pingroup. See "CAL_DRVDN" in the
> +    Tegra TRM.
> +- nvidia,pull-up-strength: Integer. Controls drive strength. 0 is weakest.
> +    The range of valid values depends on the pingroup. See "CAL_DRVUP" in the
> +    Tegra TRM.
> +- nvidia,slew-rate-rising: Integer. Controls rising signal slew rate. 0 is
> +    fastest. The range of valid values depends on the pingroup. See
> +    "DRVDN_SLWR" in the Tegra TRM.
> +- nvidia,slew-rate-falling: Integer. Controls falling signal slew rate. 0 is
> +    fastest. The range of valid values depends on the pingroup. See
> +    "DRVUP_SLWF" in the Tegra TRM.
> +
> +Note that many of these properties are only valid for certain specific pins
> +or groups. See the Tegra TRM and various pinmux spreadsheets for complete
> +details regarding which groups support which functionality. The Linux pinctrl
> +driver may also be a useful reference, since it consolidates, disambiguates,
> +and corrects data from all those sources.
> +
> +Valid values for pin and group names are:
> +
> +  mux groups:
> +
> +    These all support nvidia,function, nvidia,tristate, and many support
> +    nvidia,pull.
> +
> +    ata, atb, atc, atd, ate, cdev1, cdev2, crtp, csus, dap1, dap2, dap3, dap4,
> +    ddc, dta, dtb, dtc, dtd, dte, dtf, gma, gmb, gmc, gmd, gme, gpu, gpu7,
> +    gpv, hdint, i2cp, irrx, irtx, kbca, kbcb, kbcc, kbcd, kbce, kbcf, lcsn,
> +    ld0, ld1, ld2, ld3, ld4, ld5, ld6, ld7, ld8, ld9, ld10, ld11, ld12, ld13,
> +    ld14, ld15, ld16, ld17, ldc, ldi, lhp0, lhp1, lhp2, lhs, lm0, lm1, lpp,
> +    lpw0, lpw1, lpw2, lsc0, lsc1, lsck, lsda, lsdi, lspi, lvp0, lvp1, lvs,
> +    owc, pmc, pta, rm, sdb, sdc, sdd, sdio1, slxa, slxc, slxd, slxk, spdi,
> +    spdo, spia, spib, spic, spid, spie, spif, spig, spih, uaa, uab, uac, uad,
> +    uca, ucb, uda.
> +
> +  tristate groups:
> +
> +    These only support nvidia,pull.
> +
> +    ck32, ddrc, pmca, pmcb, pmcc, pmcd, pmce, xm2c, xm2d, ls, lc, ld17_0,
> +    ld19_18, ld21_20, ld23_22.
> +
> +  drive groups:
> +
> +    With some exceptions, these support nvidia,high-speed-mode,
> +    nvidia,schmitt, nvidia,low-power-mode, nvidia,pull-down-strength,
> +    nvidia,pull-up-strength, nvidia,slew_rate-rising, nvidia,slew_rate-falling.
> +
> +    drive_ao1, drive_ao2, drive_at1, drive_at2, drive_cdev1, drive_cdev2,
> +    drive_csus, drive_dap1, drive_dap2, drive_dap3, drive_dap4, drive_dbg,
> +    drive_lcd1, drive_lcd2, drive_sdmmc2, drive_sdmmc3, drive_spi, drive_uaa,
> +    drive_uab, drive_uart2, drive_uart3, drive_vi1, drive_vi2, drive_xm2a,
> +    drive_xm2c, drive_xm2d, drive_xm2clk, drive_sdio1, drive_crt, drive_ddc,
> +    drive_gma, drive_gmb, drive_gmc, drive_gmd, drive_gme, drive_owr,
> +    drive_uda.
> +
> +Example:
> +
> +       pinctrl@70000000 {
> +               compatible = "nvidia,tegra20-pinmux";
> +               reg = < 0x70000014 0x10    /* Tri-state registers */
> +                       0x70000080 0x20    /* Mux registers */
> +                       0x700000a0 0x14    /* Pull-up/down registers */
> +                       0x70000868 0xa8 >; /* Pad control registers */
> +       };
> +
> +Example board file extract:
> +
> +       pinctrl@70000000 {
> +               sdio4_default: sdio4_default {
> +                       atb {
> +                               nvidia,pins = "atb", "gma", "gme";
> +                               nvidia,function = "sdio4";
> +                               nvidia,pull = <0>;
> +                               nvidia,tristate = <0>;
> +                       };
> +               };
> +       };
> +
> +       sdhci@c8000600 {
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&sdio4_default>;
> +       };
> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
> new file mode 100644
> index 0000000..c275b70
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
> @@ -0,0 +1,132 @@
> +NVIDIA Tegra30 pinmux controller
> +
> +The Tegra30 pinctrl binding is very similar to the Tegra20 pinctrl binding,
> +as described in nvidia,tegra20-pinmux.txt. In fact, this document assumes
> +that binding as a baseline, and only documents the differences between the
> +two bindings.
> +
> +Required properties:
> +- compatible: "nvidia,tegra30-pinmux"
> +- reg: Should contain the register physical address and length for each of
> +  the pad control and mux registers.
> +
> +Tegra30 adds the following optional properties for pin configuration subnodes:
> +- nvidia,enable-input: Integer. Enable the pin's input path. 0: no, 1: yes.
> +- nvidia,open-drain: Integer. Enable open drain mode. 0: no, 1: yes.
> +- nvidia,lock: Integer. Lock the pin configuration against further changes
> +    until reset. 0: no, 1: yes.
> +- nvidia,io-reset: Integer. Reset the IO path. 0: no, 1: yes.
> +
> +As with Tegra20, see the Tegra TRM for complete details regarding which groups
> +support which functionality.
> +
> +Valid values for pin and group names are:
> +
> +  per-pin mux groups:
> +
> +    These all support nvidia,function, nvidia,tristate, nvidia,pull,
> +    nvidia,enable-input, nvidia,lock. Some support nvidia,open-drain,
> +    nvidia,io-reset.
> +
> +    clk_32k_out_pa0, uart3_cts_n_pa1, dap2_fs_pa2, dap2_sclk_pa3,
> +    dap2_din_pa4, dap2_dout_pa5, sdmmc3_clk_pa6, sdmmc3_cmd_pa7, gmi_a17_pb0,
> +    gmi_a18_pb1, lcd_pwr0_pb2, lcd_pclk_pb3, sdmmc3_dat3_pb4, sdmmc3_dat2_pb5,
> +    sdmmc3_dat1_pb6, sdmmc3_dat0_pb7, uart3_rts_n_pc0, lcd_pwr1_pc1,
> +    uart2_txd_pc2, uart2_rxd_pc3, gen1_i2c_scl_pc4, gen1_i2c_sda_pc5,
> +    lcd_pwr2_pc6, gmi_wp_n_pc7, sdmmc3_dat5_pd0, sdmmc3_dat4_pd1, lcd_dc1_pd2,
> +    sdmmc3_dat6_pd3, sdmmc3_dat7_pd4, vi_d1_pd5, vi_vsync_pd6, vi_hsync_pd7,
> +    lcd_d0_pe0, lcd_d1_pe1, lcd_d2_pe2, lcd_d3_pe3, lcd_d4_pe4, lcd_d5_pe5,
> +    lcd_d6_pe6, lcd_d7_pe7, lcd_d8_pf0, lcd_d9_pf1, lcd_d10_pf2, lcd_d11_pf3,
> +    lcd_d12_pf4, lcd_d13_pf5, lcd_d14_pf6, lcd_d15_pf7, gmi_ad0_pg0,
> +    gmi_ad1_pg1, gmi_ad2_pg2, gmi_ad3_pg3, gmi_ad4_pg4, gmi_ad5_pg5,
> +    gmi_ad6_pg6, gmi_ad7_pg7, gmi_ad8_ph0, gmi_ad9_ph1, gmi_ad10_ph2,
> +    gmi_ad11_ph3, gmi_ad12_ph4, gmi_ad13_ph5, gmi_ad14_ph6, gmi_ad15_ph7,
> +    gmi_wr_n_pi0, gmi_oe_n_pi1, gmi_dqs_pi2, gmi_cs6_n_pi3, gmi_rst_n_pi4,
> +    gmi_iordy_pi5, gmi_cs7_n_pi6, gmi_wait_pi7, gmi_cs0_n_pj0, lcd_de_pj1,
> +    gmi_cs1_n_pj2, lcd_hsync_pj3, lcd_vsync_pj4, uart2_cts_n_pj5,
> +    uart2_rts_n_pj6, gmi_a16_pj7, gmi_adv_n_pk0, gmi_clk_pk1, gmi_cs4_n_pk2,
> +    gmi_cs2_n_pk3, gmi_cs3_n_pk4, spdif_out_pk5, spdif_in_pk6, gmi_a19_pk7,
> +    vi_d2_pl0, vi_d3_pl1, vi_d4_pl2, vi_d5_pl3, vi_d6_pl4, vi_d7_pl5,
> +    vi_d8_pl6, vi_d9_pl7, lcd_d16_pm0, lcd_d17_pm1, lcd_d18_pm2, lcd_d19_pm3,
> +    lcd_d20_pm4, lcd_d21_pm5, lcd_d22_pm6, lcd_d23_pm7, dap1_fs_pn0,
> +    dap1_din_pn1, dap1_dout_pn2, dap1_sclk_pn3, lcd_cs0_n_pn4, lcd_sdout_pn5,
> +    lcd_dc0_pn6, hdmi_int_pn7, ulpi_data7_po0, ulpi_data0_po1, ulpi_data1_po2,
> +    ulpi_data2_po3, ulpi_data3_po4, ulpi_data4_po5, ulpi_data5_po6,
> +    ulpi_data6_po7, dap3_fs_pp0, dap3_din_pp1, dap3_dout_pp2, dap3_sclk_pp3,
> +    dap4_fs_pp4, dap4_din_pp5, dap4_dout_pp6, dap4_sclk_pp7, kb_col0_pq0,
> +    kb_col1_pq1, kb_col2_pq2, kb_col3_pq3, kb_col4_pq4, kb_col5_pq5,
> +    kb_col6_pq6, kb_col7_pq7, kb_row0_pr0, kb_row1_pr1, kb_row2_pr2,
> +    kb_row3_pr3, kb_row4_pr4, kb_row5_pr5, kb_row6_pr6, kb_row7_pr7,
> +    kb_row8_ps0, kb_row9_ps1, kb_row10_ps2, kb_row11_ps3, kb_row12_ps4,
> +    kb_row13_ps5, kb_row14_ps6, kb_row15_ps7, vi_pclk_pt0, vi_mclk_pt1,
> +    vi_d10_pt2, vi_d11_pt3, vi_d0_pt4, gen2_i2c_scl_pt5, gen2_i2c_sda_pt6,
> +    sdmmc4_cmd_pt7, pu0, pu1, pu2, pu3, pu4, pu5, pu6, jtag_rtck_pu7, pv0,
> +    pv1, pv2, pv3, ddc_scl_pv4, ddc_sda_pv5, crt_hsync_pv6, crt_vsync_pv7,
> +    lcd_cs1_n_pw0, lcd_m1_pw1, spi2_cs1_n_pw2, spi2_cs2_n_pw3, clk1_out_pw4,
> +    clk2_out_pw5, uart3_txd_pw6, uart3_rxd_pw7, spi2_mosi_px0, spi2_miso_px1,
> +    spi2_sck_px2, spi2_cs0_n_px3, spi1_mosi_px4, spi1_sck_px5, spi1_cs0_n_px6,
> +    spi1_miso_px7, ulpi_clk_py0, ulpi_dir_py1, ulpi_nxt_py2, ulpi_stp_py3,
> +    sdmmc1_dat3_py4, sdmmc1_dat2_py5, sdmmc1_dat1_py6, sdmmc1_dat0_py7,
> +    sdmmc1_clk_pz0, sdmmc1_cmd_pz1, lcd_sdin_pz2, lcd_wr_n_pz3, lcd_sck_pz4,
> +    sys_clk_req_pz5, pwr_i2c_scl_pz6, pwr_i2c_sda_pz7, sdmmc4_dat0_paa0,
> +    sdmmc4_dat1_paa1, sdmmc4_dat2_paa2, sdmmc4_dat3_paa3, sdmmc4_dat4_paa4,
> +    sdmmc4_dat5_paa5, sdmmc4_dat6_paa6, sdmmc4_dat7_paa7, pbb0,
> +    cam_i2c_scl_pbb1, cam_i2c_sda_pbb2, pbb3, pbb4, pbb5, pbb6, pbb7,
> +    cam_mclk_pcc0, pcc1, pcc2, sdmmc4_rst_n_pcc3, sdmmc4_clk_pcc4,
> +    clk2_req_pcc5, pex_l2_rst_n_pcc6, pex_l2_clkreq_n_pcc7,
> +    pex_l0_prsnt_n_pdd0, pex_l0_rst_n_pdd1, pex_l0_clkreq_n_pdd2,
> +    pex_wake_n_pdd3, pex_l1_prsnt_n_pdd4, pex_l1_rst_n_pdd5,
> +    pex_l1_clkreq_n_pdd6, pex_l2_prsnt_n_pdd7, clk3_out_pee0, clk3_req_pee1,
> +    clk1_req_pee2, hdmi_cec_pee3, clk_32k_in, core_pwr_req, cpu_pwr_req, owr,
> +    pwr_int_n.
> +
> +  drive groups:
> +
> +    These all support nvidia,pull-down-strength, nvidia,pull-up-strength,
> +    nvidia,slew_rate-rising, nvidia,slew_rate-falling. Most but not all
> +    support nvidia,high-speed-mode, nvidia,schmitt, nvidia,low-power-mode.
> +
> +    ao1, ao2, at1, at2, at3, at4, at5, cdev1, cdev2, cec, crt, csus, dap1,
> +    dap2, dap3, dap4, dbg, ddc, dev3, gma, gmb, gmc, gmd, gme, gmf, gmg,
> +    gmh, gpv, lcd1, lcd2, owr, sdio1, sdio2, sdio3, spi, uaa, uab, uart2,
> +    uart3, uda, vi1.
> +
> +Example:
> +
> +       pinctrl@70000000 {
> +               compatible = "nvidia,tegra30-pinmux";
> +               reg = < 0x70000868 0xd0     /* Pad control registers */
> +                       0x70003000 0x3e0 >; /* Mux registers */
> +       };
> +
> +Example board file extract:
> +
> +       pinctrl@70000000 {
> +               sdmmc4_default: pinmux {
> +                       sdmmc4_clk_pcc4 {
> +                               nvidia,pins =   "sdmmc4_clk_pcc4",
> +                                               "sdmmc4_rst_n_pcc3";
> +                               nvidia,function = "sdmmc4";
> +                               nvidia,pull = <0>;
> +                               nvidia,tristate = <0>;
> +                       };
> +                       sdmmc4_dat0_paa0 {
> +                               nvidia,pins =   "sdmmc4_dat0_paa0",
> +                                               "sdmmc4_dat1_paa1",
> +                                               "sdmmc4_dat2_paa2",
> +                                               "sdmmc4_dat3_paa3",
> +                                               "sdmmc4_dat4_paa4",
> +                                               "sdmmc4_dat5_paa5",
> +                                               "sdmmc4_dat6_paa6",
> +                                               "sdmmc4_dat7_paa7";

I see that you have done with a hierarchical approach which I like a lot.

However, the large number of strings here (using a string to name a
function and a pin) is going to create quite a bit of overhead, not to
mention FDT space.

Have you given up on the /define/ patch that you created?

If so, I wonder if we could at least provide an alternate binding
using numbering. I have just figured out how to get the C preprocessor
out of U-Boot's FDT path, but if that is the only way, perhaps the
kernel should use that to get numbered symbols?

I would much prefer a parallel property which provides the names, that
can be omitted.

(Similarly for your 'nvidia,pull' property, it would be nice to have a
symbolic name)

> +                               nvidia,function = "sdmmc4";
> +                               nvidia,pull = <2>;
> +                               nvidia,tristate = <0>;
> +                       };
> +               };
> +       };
> +
> +       sdhci@78000400 {
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&sdmmc4_default>;
> +       };
> --
> 1.7.0.4
>

Regards,
Simon
