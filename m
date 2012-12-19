Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab2LSF74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:59:56 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:43547 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2LSF7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:59:47 -0500
MIME-Version: 1.0
In-Reply-To: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 19 Dec 2012 11:07:37 +0530
Message-ID: <CAFp+6iEWPQH2f8zeR734U8Sy_tA3gguROYpvQa2nudNwxXyuRQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Adding usb2.0 host-phy support for exynos5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-usb@vger.kernel.org
Cc: dianders@chromium.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, jg1.han@samsung.com,
        yulgon.kim@samsung.com, kishon@ti.com, p.paneri@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Anderson


On Tue, Dec 18, 2012 at 8:13 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Changes from v4:
>  - Moved architecture side changes out of this patch-set.
>  - Added support for multiple usbphy phandle parsing and
>    doing all pmu_isolation() and phy_cfg_sel() related changes
>    in samsung-usbphy driver only instead of architecture
>    as in v4 patch-set.
>  - Removed unnecessary multi line definitions for macros.
>
> Changes from v3:
>  - Moved enums S5P_USB_PHY_DEVICE, S5P_USB_PHY_HOST from machine to file
>    include/linux/usb/samsung_usb_phy.h as USB_PHY_TYPE_DEVICE and
>    USB_PHY_TYPE_HOST to make it more generic. Further resolve its
>    dependencies.
>  - Introduced a function 'samsung_usbphy_set_type()' which takes
>    care of setting up the phy_type: HOST/DEVICE. This function
>    can be called by host/otg drivers to setup phy_type prior to
>    handling the respective PHYs.
>  - Added an error-path for HOST type phy in s5p_usb_phy_pmu_isolation()
>    for 'mach-s3c64xx'.
>  - Moving to PHY driver as default for ehci-s5p and ohci-exynos, and only
>    when failed fall back to plat-data.
>  - Added samsung_usbphy_set_type() prior to doing usb_phy_init() or
>    usb_phy_shutdown() so that appropriate PHY gets init or shutdown.
>
> Based on patches for samsung-usbphy driver:
>  1)http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/134476.html
>  2)https://lkml.org/lkml/2012/12/18/187
>
> Vivek Gautam (4):
>   ARM: EXYNOS: Update & move usb-phy types to generic include layer
>   usb: phy: samsung: Add host phy support to samsung-phy driver
>   USB: ehci-s5p: Add phy driver support
>   USB: ohci-exynos: Add phy driver support
>
>  .../devicetree/bindings/usb/samsung-usbphy.txt     |   25 +-
>  drivers/usb/host/ehci-s5p.c                        |   71 +++-
>  drivers/usb/host/ohci-exynos.c                     |   71 +++-
>  drivers/usb/phy/Kconfig                            |    2 +-
>  drivers/usb/phy/samsung-usbphy.c                   |  465 ++++++++++++++++++--
>  include/linux/usb/samsung_usb_phy.h                |   29 ++
>  6 files changed, 570 insertions(+), 93 deletions(-)
>  create mode 100644 include/linux/usb/samsung_usb_phy.h
>
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks & Regards
Vivek
