Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0HYJxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:53:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40442 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0HYJxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:53:15 -0400
Subject: Re: [PATCH] ASoC: pxa-ssp: fix a memory leak in pxa_ssp_remove()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1282726751.5051.4.camel@mola>
References: <1282726751.5051.4.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 10:53:09 +0100
Message-ID: <1282729989.2991.153.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 16:59 +0800, Axel Lin wrote:
> The "priv" allocated in pxa_ssp_probe() should be kfreed in pxa_ssp_remove().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against 2.6.36-rc2-git3.
>  sound/soc/pxa/pxa-ssp.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
> index a1fd23e..2a9cac7 100644
> --- a/sound/soc/pxa/pxa-ssp.c
> +++ b/sound/soc/pxa/pxa-ssp.c
> @@ -760,6 +760,7 @@ static void pxa_ssp_remove(struct platform_device *pdev,
>  {
>  	struct ssp_priv *priv = dai->private_data;
>  	pxa_ssp_free(priv->ssp);
> +	kfree(priv);
>  }
>  
>  #define PXA_SSP_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\

Acked-by:Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

