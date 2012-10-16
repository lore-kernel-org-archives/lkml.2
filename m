Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2JPVfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:35:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37710 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2JPVfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:35:18 -0400
Date: Tue, 16 Oct 2012 23:35:08 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 04/10] ASoC: imx: Don't use {en,dis}able_fiq() calls
Message-ID: <20121016213508.GF27665@pengutronix.de>
References: <20121015214954.GA3352@lizard>
 <1350337894-9744-4-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350337894-9744-4-git-send-email-anton.vorontsov@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 23:34:47 up 115 days, 12:46, 44 users,  load average: 3.74, 6.98,
 7.85
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 02:51:28PM -0700, Anton Vorontsov wrote:
> The driver uses platform-specific mxc_set_irq_fiq() with the VIRQ cookie
> passed to it, so it's pretty clear that the driver is absolutely sure
> that the FIQ is routed via platform-specific IC, and that the cookie can
> be used to mask/unmask FIQs. So, let's switch to the genirq routines,
> since we're about to remove FIQ-specific variants.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  sound/soc/fsl/imx-pcm-fiq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/fsl/imx-pcm-fiq.c b/sound/soc/fsl/imx-pcm-fiq.c
> index 22c6130..8f1a4a6 100644
> --- a/sound/soc/fsl/imx-pcm-fiq.c
> +++ b/sound/soc/fsl/imx-pcm-fiq.c
> @@ -139,7 +139,7 @@ static int snd_imx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
>  		hrtimer_start(&iprtd->hrt, ns_to_ktime(iprtd->poll_time_ns),
>  		      HRTIMER_MODE_REL);
>  		if (++fiq_enable == 1)
> -			enable_fiq(imx_pcm_fiq);
> +			enable_irq(imx_pcm_fiq);
>  
>  		break;
>  
> @@ -149,7 +149,7 @@ static int snd_imx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
>  		atomic_set(&iprtd->running, 0);
>  
>  		if (--fiq_enable == 0)
> -			disable_fiq(imx_pcm_fiq);
> +			disable_irq(imx_pcm_fiq);
>  
>  		break;
>  	default:
> -- 
> 1.7.12.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
