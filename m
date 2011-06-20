Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1FTMHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:07:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55270 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1FTMHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:07:32 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: Tushar Behera <tushar.behera@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "Nilofer, Samreen" <samreen@ti.com>
Date: Mon, 20 Jun 2011 17:37:07 +0530
Subject: RE: [PATCH 1/2] config: omap2+: force fb and dss support as built-in
Thread-Topic: [PATCH 1/2] config: omap2+: force fb and dss support as
 built-in
Thread-Index: AcwvN19gEJ7Y1X0qS8m6gKiRvpoONAACv7gg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D625A5C@dbde02.ent.ti.com>
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>
 <1308566761-2850-2-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1308566761-2850-2-git-send-email-tushar.behera@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org 
> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Tushar Behera
> Sent: Monday, June 20, 2011 4:16 PM
> To: linux-kernel@vger.kernel.org; 
> linux-arm-kernel@lists.infradead.org; 
> linux-fbdev@vger.kernel.org; linux-omap@vger.kernel.org
> Cc: linux@arm.linux.org.uk; tony@atomide.com; 
> lethal@linux-sh.org; linaro-dev@lists.linaro.org; 
> patches@linaro.org; Nilofer, Samreen
> Subject: [PATCH 1/2] config: omap2+: force fb and dss support 
> as built-in
> 
> In certain board files, there are references to vram related functions
> which are defined in drivers/video/omap2/vram.c. Because of 
> this direct
> dependency, CONFIG_FB_OMAP2 should be a built-in feature.
> 
> As per the current architecture, CONFIG_FB_OMAP2 is dependent on
> CONFIG_OMAP2_DSS. Hence CONFIG_OMAP2_DSS support should also 
> be selected
> by default.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Samreen <samreen@ti.com>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> arch/arm/mach-omap2/built-in.o: In function `rx51_video_mem_init':
> linux-linaro-2.6.39/arch/arm/mach-omap2/board-rx51-video.c:97:
>  undefined reference to `omap_vram_set_sdram_vram'
> arch/arm/plat-omap/built-in.o: In function `omap_reserve':
> linux-linaro-2.6.39/arch/arm/plat-omap/common.c:66: undefined 
> reference to `omap_vram_reserve_sdram_memblock'
> arch/arm/plat-omap/built-in.o: In function `omap_detect_sram':
> linux-linaro-2.6.39/arch/arm/plat-omap/sram.c:179: undefined 
> reference to `omap_vram_reserve_sram'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2
> 
>  arch/arm/configs/omap2plus_defconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/configs/omap2plus_defconfig 
> b/arch/arm/configs/omap2plus_defconfig
> index d5f00d7..c3ffff2 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -138,11 +138,11 @@ CONFIG_FIRMWARE_EDID=y
>  CONFIG_FB_MODE_HELPERS=y
>  CONFIG_FB_TILEBLITTING=y
>  CONFIG_FB_OMAP_LCD_VGA=y
> -CONFIG_OMAP2_DSS=m
> +CONFIG_OMAP2_DSS=y
>  CONFIG_OMAP2_DSS_RFBI=y
>  CONFIG_OMAP2_DSS_SDI=y
>  CONFIG_OMAP2_DSS_DSI=y
> -CONFIG_FB_OMAP2=m
> +CONFIG_FB_OMAP2=y
>  CONFIG_PANEL_GENERIC_DPI=m
>  CONFIG_PANEL_SHARP_LS037V7DW01=m
>  CONFIG_PANEL_NEC_NL8048HL11_01B=m


[sp] Instead of changing the omap2plus_defconfig, shouldn't the
     board specific file be fixed instead?

~sanjeev

> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 