Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1HVKTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:19:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50874 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1HVKTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:19:18 -0400
Message-ID: <4E522D02.9020809@ti.com>
Date: Mon, 22 Aug 2011 11:18:42 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Timur Tabi <timur@freescale.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] sound/soc/fsl/fsl_dma.c: add missing of_node_put
References: <1313825025-17590-1-git-send-email-julia@diku.dk>
In-Reply-To: <1313825025-17590-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/11 08:23, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> of_parse_phandle increments the reference count of np, so this should be
> decremented before trying the next possibility.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e,e1,e2;
> @@
> 
> *e = of_parse_phandle(...)
> ... when != of_node_put(e)
>     when != true e == NULL
>     when != e2 = e
> e = e1
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  sound/soc/fsl/fsl_dma.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
> index 0efc04a..b33271b 100644
> --- a/sound/soc/fsl/fsl_dma.c
> +++ b/sound/soc/fsl/fsl_dma.c
> @@ -880,10 +880,12 @@ static struct device_node *find_ssi_node(struct device_node *dma_channel_np)
>  		np = of_parse_phandle(ssi_np, "fsl,playback-dma", 0);
>  		if (np == dma_channel_np)
>  			return ssi_np;
> +		of_node_put(np);
>  
>  		np = of_parse_phandle(ssi_np, "fsl,capture-dma", 0);
>  		if (np == dma_channel_np)
>  			return ssi_np;
> +		of_node_put(np);
>  	}
>  
>  	return NULL;
> 

Acked-by: Liam Girdwood <lrg@ti.com>
