Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2LSFrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:47:18 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:45504 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2LSFrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:47:13 -0500
MIME-Version: 1.0
In-Reply-To: <1355845182-14104-2-git-send-email-gautam.vivek@samsung.com>
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
	<1355845182-14104-2-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 19 Dec 2012 11:17:11 +0530
Message-ID: <CAFp+6iFHwBx7aRFR7BN8iWCnHMb-U8ttqChHFhuC_L3Oo+=Dgw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: Exynos5250: Enabling samsung-usbphy driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: dianders@chromium.org, kgene.kim@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com, p.paneri@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Anderson.


On Tue, Dec 18, 2012 at 9:09 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Adding usbphy node for Exynos5250 along with the
> necessary device data to be parsed.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi       |   22 ++++++++++++++++++++++
>  arch/arm/mach-exynos/include/mach/map.h |    1 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c  |    2 ++
>  3 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 581e57a..bbdb2c2 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -299,6 +299,28 @@
>                 rx-dma-channel = <&pdma0 11>; /* preliminary */
>         };
>
> +       phy_h0: usbdev_phyctrl@10040704 {
> +               compatible = "samsung,usbdev-phyctrl";
> +               samsung,phyhandle-reg = <0x10040704>;
> +       };
> +
> +       phy_h1: usbhost_phyctrl@10040708 {
> +               compatible = "samsung,usbhost-phyctrl";
> +               samsung,phyhandle-reg = <0x10040708>;
> +       };
> +
> +       phy_h2: usbhost_phycfg@10050230 {
> +               compatible = "samsung,usb-phycfg";
> +               samsung,phyhandle-reg = <0x10050230>;
> +       };
> +
> +       usbphy@12130000 {
> +               compatible = "samsung,exynos5250-usbphy";
> +               reg = <0x12130000 0x100>;
> +               samsung,usb-phyhandle = <&phy_h0 &phy_h1 &phy_h2>;
> +               samsung,enable-mask = <1>;
> +       };
> +
>         amba {
>                 #address-cells = <1>;
>                 #size-cells = <1>;
> diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
> index cbb2852..778348e 100644
> --- a/arch/arm/mach-exynos/include/mach/map.h
> +++ b/arch/arm/mach-exynos/include/mach/map.h
> @@ -201,6 +201,7 @@
>  #define EXYNOS4_PA_EHCI                        0x12580000
>  #define EXYNOS4_PA_OHCI                        0x12590000
>  #define EXYNOS4_PA_HSPHY               0x125B0000
> +#define EXYNOS5_PA_HSPHY               0x12130000
>  #define EXYNOS4_PA_MFC                 0x13400000
>
>  #define EXYNOS4_PA_UART                        0x13800000
> diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
> index 462e5ac..24e7529 100644
> --- a/arch/arm/mach-exynos/mach-exynos5-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
> @@ -110,6 +110,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
>                                 "samsung-i2s.1", NULL),
>         OF_DEV_AUXDATA("samsung,samsung-i2s", 0x12D70000,
>                                 "samsung-i2s.2", NULL),
> +       OF_DEV_AUXDATA("samsung,exynos5250-usbphy", EXYNOS5_PA_HSPHY,
> +                               "s3c-usbphy", NULL),
>         {},
>  };
>
> --
> 1.7.6.5
>
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss



-- 
Thanks & Regards
Vivek
