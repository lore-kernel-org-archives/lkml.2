Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2KWIpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:45:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49163 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2KWIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <1352188180-10028-1-git-send-email-qingx@marvell.com>
References: <1352188180-10028-1-git-send-email-qingx@marvell.com>
Date: Fri, 23 Nov 2012 16:45:08 +0800
Message-ID: <CAN1soZy+JCfsroyUBFe9M_MW-sakcWwuqQMT5h0=+Haq+SJ5fw@mail.gmail.com>
Subject: Re: [PATCH 7/7] mfd: max8925: add dts
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Qing Xu <qingx@marvell.com>
Cc: Linux Russell <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, cxie4@marvell.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 3:49 PM, Qing Xu <qingx@marvell.com> wrote:
> From: Qing Xu <qingx@marvell.com>
>
> add max8925 dts support into mmp2 brownstone platform
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>  arch/arm/boot/dts/mmp2-brownstone.dts |  166 +++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/mmp2.dtsi           |    4 +-
>  2 files changed, 169 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
> index c9b4f27..e22f58c 100644
> --- a/arch/arm/boot/dts/mmp2-brownstone.dts
> +++ b/arch/arm/boot/dts/mmp2-brownstone.dts
> @@ -29,6 +29,172 @@
>                         };
>                         twsi1: i2c@d4011000 {
>                                 status = "okay";
> +                               pmic: max8925@3c {
> +                                       compatible = "marvell,max8925";
> +                                       reg = <0x3c>;
> +                                       interrupts = <1 0>;
> +                                       interrupt-parent = <&intcmux4>;
> +                                       interrupt-controller;
> +                                       #interrupt-cells = <1>;
> +
> +                                       regulators {
> +                                               SDV1 {
> +                                                       regulator-min-microvolt = <637500>;
> +                                                       regulator-max-microvolt = <1425000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                               SDV2 {
> +                                                       regulator-min-microvolt = <650000>;
> +                                                       regulator-max-microvolt = <2225000>;
> +                                                       regulator-boot-on;
> +                                                       regulator-always-on;
> +                                               };
> +                                       };
> +                                       backlight {
> +                                               dual-string = <0>;
> +                                       };
> +                                       charger {
> +                                               batt-detect = <0>;
> +                                               topoff-threshold = <1>;
> +                                               fast-charge = <7>;
> +                                               no-temp-support = <0>;
> +                                               no-insert-detect = <0>;
> +                                       };
> +                                       rtc {
> +
> +                                       };
> +                                       onkey {
> +
> +                                       };
> +                                       touch {
> +
> +                                       };

Please remove these empty entries. Those mfd client drivers didn't parse any
property from DTS file.

> +                               };
>                         };
>                         rtc: rtc@d4010000 {
>                                 status = "okay";
> diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
> index 80f74e2..2165a17 100644
> --- a/arch/arm/boot/dts/mmp2.dtsi
> +++ b/arch/arm/boot/dts/mmp2.dtsi
> @@ -41,7 +41,7 @@
>                                 mrvl,intc-nr-irqs = <64>;
>                         };
>
> -                       intcmux4@d4282150 {
> +                       intcmux4: intcmux4@d4282150 {
>                                 compatible = "mrvl,mmp2-mux-intc";
>                                 interrupts = <4>;
>                                 interrupt-controller;
> @@ -196,6 +196,8 @@
>                                 compatible = "mrvl,mmp-twsi";
>                                 reg = <0xd4011000 0x1000>;
>                                 interrupts = <7>;
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
>                                 mrvl,i2c-fast-mode;
>                                 status = "disabled";
>                         };
> --
> 1.7.0.4
>
