Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1HVUGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:06:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37394 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab1HVUGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:06:07 -0400
Message-ID: <4E52B692.2030601@ti.com>
Date: Mon, 22 Aug 2011 21:05:38 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "julia@diku.dk" <julia@diku.dk>
Subject: Re: [PATCH] [v2] sound/soc/fsl/fsl_dma.c: add missing of_node_put
References: <1314022961-27513-1-git-send-email-timur@freescale.com>
In-Reply-To: <1314022961-27513-1-git-send-email-timur@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/11 15:22, Timur Tabi wrote:
> of_parse_phandle increments the reference count of np, so this should be
> decremented before trying the next possibility.
> 
> Since we don't actually use np, we can decrement the reference count
> immediately.
> 
> Reported-by: Julia Lawall <julia@diku.dk>
> Signed-off-by: Timur Tabi <timur@freescale.com>

Acked-by: Liam Girdwood <lrg@ti.com>

> ---
>  sound/soc/fsl/fsl_dma.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
> index 6680c0b..b300f4b 100644
> --- a/sound/soc/fsl/fsl_dma.c
> +++ b/sound/soc/fsl/fsl_dma.c
> @@ -877,10 +877,12 @@ static struct device_node *find_ssi_node(struct device_node *dma_channel_np)
>  		 * assume that device_node pointers are a valid comparison.
>  		 */
>  		np = of_parse_phandle(ssi_np, "fsl,playback-dma", 0);
> +		of_node_put(np);
>  		if (np == dma_channel_np)
>  			return ssi_np;
>  
>  		np = of_parse_phandle(ssi_np, "fsl,capture-dma", 0);
> +		of_node_put(np);
>  		if (np == dma_channel_np)
>  			return ssi_np;
>  	}

