Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab1FARNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:13:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52888 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758978Ab1FARNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:13:18 -0400
Message-ID: <4DE6730E.7040403@ti.com>
Date: Wed, 1 Jun 2011 18:12:46 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wan ZongShun <mcuos.com@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        Timur Tabi <timur@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/10] sound/soc/nuc900/nuc900-ac97.c: add missing clk_put
References: <1306948213-20767-2-git-send-email-julia@diku.dk>
In-Reply-To: <1306948213-20767-2-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/11 18:10, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> This goto is after the call to clk_get, so it should go to the label that
> includes a call to clk_put.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression e1,e2;
> statement S;
> @@
> 
> e1 = clk_get@p1(...);
> ... when != e1 = e2
>     when != clk_put(e1)
>     when any
> if (...) { ... when != clk_put(e1)
>                when != if (...) { ... clk_put(e1) ... }
> * return@p3 ...;
>  } else S
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  sound/soc/nuc900/nuc900-ac97.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
> index dac6732..9c0edad 100644
> --- a/sound/soc/nuc900/nuc900-ac97.c
> +++ b/sound/soc/nuc900/nuc900-ac97.c
> @@ -356,7 +356,7 @@ static int __devinit nuc900_ac97_drvprobe(struct platform_device *pdev)
>  	nuc900_audio->irq_num = platform_get_irq(pdev, 0);
>  	if (!nuc900_audio->irq_num) {
>  		ret = -EBUSY;
> -		goto out2;
> +		goto out3;
>  	}
>  
>  	nuc900_ac97_data = nuc900_audio;
> 

Acked-by: Liam Girdwood <lrg@ti.com>
