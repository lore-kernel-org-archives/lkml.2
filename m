Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1FTNEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:04:54 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:45802 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960Ab1FTNEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:04:52 -0400
Subject: Re: [PATCH 1/2] config: omap2+: force fb and dss support as
 built-in
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, tony@atomide.com, lethal@linux-sh.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samreen <samreen@ti.com>
In-Reply-To: <1308566761-2850-2-git-send-email-tushar.behera@linaro.org>
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>
	 <1308566761-2850-2-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 16:04:46 +0300
Message-ID: <1308575086.2076.55.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 16:16 +0530, Tushar Behera wrote:
> In certain board files, there are references to vram related functions
> which are defined in drivers/video/omap2/vram.c. Because of this direct
> dependency, CONFIG_FB_OMAP2 should be a built-in feature.

arch/arm/plat-omap/include/plat/vram.h defines dummy inline function in
case vram.c is not compiled in, so the board files should compile fine.

> As per the current architecture, CONFIG_FB_OMAP2 is dependent on
> CONFIG_OMAP2_DSS. Hence CONFIG_OMAP2_DSS support should also be selected
> by default.

The configuration is fine as it is. And anyway, if things do not compile
when something is configured as a module, the correct fix is hardly just
changing the feature to be compiled built-in =).

> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Samreen <samreen@ti.com>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> arch/arm/mach-omap2/built-in.o: In function `rx51_video_mem_init':
> linux-linaro-2.6.39/arch/arm/mach-omap2/board-rx51-video.c:97: undefined reference to `omap_vram_set_sdram_vram'
> arch/arm/plat-omap/built-in.o: In function `omap_reserve':
> linux-linaro-2.6.39/arch/arm/plat-omap/common.c:66: undefined reference to `omap_vram_reserve_sdram_memblock'
> arch/arm/plat-omap/built-in.o: In function `omap_detect_sram':
> linux-linaro-2.6.39/arch/arm/plat-omap/sram.c:179: undefined reference to `omap_vram_reserve_sram'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2

Compiles fine for me. Perhaps you are using some old kernel?

 Tomi


