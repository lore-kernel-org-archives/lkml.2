Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab2HHGwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:52:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48961 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2HHGws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:52:48 -0400
Date: Wed, 8 Aug 2012 08:52:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Dave Martin <dave.martin@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 2/2] ARM: only build ssi-fiq.S et al if
 CONFIG_SND_IMX_SOC_PCM_FIQ is selected
Message-ID: <20120808065241.GG24458@pengutronix.de>
References: <1344379514-30076-1-git-send-email-matt@genesi-usa.com>
 <1344379514-30076-3-git-send-email-matt@genesi-usa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344379514-30076-3-git-send-email-matt@genesi-usa.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:51:11 up 45 days, 22:02, 38 users,  load average: 1.34, 0.88,
 0.56
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 05:45:14PM -0500, Matt Sealey wrote:
> Further to the previous patch, a custom configuration may be used based on the
> imx_v6_v7_defconfig which removes the board depending on the audio driver pulling
> this support code. However, since it is built dependent on CONFIG_SND_IMX_SOC
> it is enabled in the build for all i.MX processors which enable any audio drivers.
> 
> Correct this by only building the SSI FIQ support code when the more specific
> CONFIG_SND_IMX_SOC_PCM_FIQ is enabled. Since it's enabled in the imx_v6_v7_defconfig
> anyway by the Eukrea board, nothing changes using the defconfig, so this is just
> a convenience for people reconfiguring their kernels more sparsely than the default.
> 
> Signed-off-by: Matt Sealey <matt@genesi-usa.com>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  arch/arm/plat-mxc/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
> index 6ac7200..89927f5 100644
> --- a/arch/arm/plat-mxc/Makefile
> +++ b/arch/arm/plat-mxc/Makefile
> @@ -16,7 +16,7 @@ obj-$(CONFIG_MXC_USE_EPIT) += epit.o
>  obj-$(CONFIG_MXC_DEBUG_BOARD) += 3ds_debugboard.o
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpufreq.o
>  obj-$(CONFIG_CPU_IDLE) += cpuidle.o
> -ifdef CONFIG_SND_IMX_SOC
> +ifdef CONFIG_SND_IMX_SOC_PCM_FIQ
>  obj-y += ssi-fiq.o
>  obj-y += ssi-fiq-ksym.o
>  endif

Since you are here already, better do:

obj-$(CONFIG_SND_IMX_SOC_PCM_FIQ) +) += ssi-fiq.o ssi-fiq-ksym.o

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
