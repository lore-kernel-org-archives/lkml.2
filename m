Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1EYLPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:15:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55036 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755446Ab1EYLPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:15:51 -0400
Date: Wed, 25 May 2011 19:15:46 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] ASoc: sam9g20_wm8731: use the proper SYSCKL value
Message-ID: <20110525111545.GD10797@opensource.wolfsonmicro.com>
References: <1306230676-28688-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306230676-28688-1-git-send-email-nicolas.ferre@atmel.com>
X-Cookie: There is a 20% chance of tomorrow.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:51:16AM +0200, Nicolas Ferre wrote:
> at91sam9g20 is providing master clock to wm8731: not using a crystal but an
> external MCLK. We can avoid conflict and save power using WM8731_SYSCLK_MCLK as
> we do not need oscillator to be powered.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Adding Liam.

> ---
>  sound/soc/atmel/sam9g20_wm8731.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
> index 28afbbf..95572d2 100644
> --- a/sound/soc/atmel/sam9g20_wm8731.c
> +++ b/sound/soc/atmel/sam9g20_wm8731.c
> @@ -146,7 +146,7 @@ static int at91sam9g20ek_wm8731_init(struct snd_soc_pcm_runtime *rtd)
>  			"at91sam9g20ek_wm8731 "
>  			": at91sam9g20ek_wm8731_init() called\n");
>  
> -	ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_XTAL,
> +	ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_MCLK,
>  		MCLK_RATE, SND_SOC_CLOCK_IN);
>  	if (ret < 0) {
>  		printk(KERN_ERR "Failed to set WM8731 SYSCLK: %d\n", ret);
> -- 
> 1.7.3
> 
