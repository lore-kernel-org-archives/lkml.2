Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab1HVKTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:19:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34303 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1HVKS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:18:57 -0400
Message-ID: <4E522CE9.7050102@ti.com>
Date: Mon, 22 Aug 2011 11:18:17 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Timur Tabi <timur@freescale.com>, Axel Lin <axel.lin@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/2] sound/soc/fsl/p1022_ds.c: add missing of_node_put
References: <1313823721-16930-1-git-send-email-julia@diku.dk>
In-Reply-To: <1313823721-16930-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/11 08:02, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> dma_channel_np has been accessed at this point, so decrease its reference
> count before leaving the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier x;
> expression E1!=0,E2,E3,E4;
> statement S;
> iterator I;
> @@
> 
> (
> if (...) { ... when != of_node_put(x)
>                when != x = E3
>                when != E3 = x
> *  return ...;
>  }
> ... when != x = E2
>     when != I(...,x,...) S
> if (...) { ... when != x = E4
>  of_node_put(x); ... return ...; }
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  sound/soc/fsl/p1022_ds.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/soc/fsl/p1022_ds.c b/sound/soc/fsl/p1022_ds.c
> index 8fa4d5f..fcb862e 100644
> --- a/sound/soc/fsl/p1022_ds.c
> +++ b/sound/soc/fsl/p1022_ds.c
> @@ -297,8 +297,10 @@ static int get_dma_channel(struct device_node *ssi_np,
>  	 * dai->platform name should already point to an allocated buffer.
>  	 */
>  	ret = of_address_to_resource(dma_channel_np, 0, &res);
> -	if (ret)
> +	if (ret) {
> +		of_node_put(dma_channel_np);
>  		return ret;
> +	}
>  	snprintf((char *)dai->platform_name, DAI_NAME_SIZE, "%llx.%s",
>  		 (unsigned long long) res.start, dma_channel_np->name);
>  
> 

Both

Acked-by: Liam Girdwood <lrg@ti.com>
