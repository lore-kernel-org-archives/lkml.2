Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1HVOGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:06:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47790 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab1HVOGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:06:50 -0400
Date: Mon, 22 Aug 2011 16:06:43 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Timur Tabi <timur@freescale.com>
Cc: kernel-janitors@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] sound/soc/fsl/fsl_dma.c: add missing of_node_put
In-Reply-To: <4E5261A5.5050608@freescale.com>
Message-ID: <Pine.LNX.4.64.1108221606220.10948@ask.diku.dk>
References: <1313825025-17590-1-git-send-email-julia@diku.dk>
 <4E5261A5.5050608@freescale.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, Timur Tabi wrote:

> Julia Lawall wrote:
> > diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
> > index 0efc04a..b33271b 100644
> > --- a/sound/soc/fsl/fsl_dma.c
> > +++ b/sound/soc/fsl/fsl_dma.c
> > @@ -880,10 +880,12 @@ static struct device_node *find_ssi_node(struct device_node *dma_channel_np)
> >  		np = of_parse_phandle(ssi_np, "fsl,playback-dma", 0);
> >  		if (np == dma_channel_np)
> >  			return ssi_np;
> > +		of_node_put(np);
> >  
> >  		np = of_parse_phandle(ssi_np, "fsl,capture-dma", 0);
> >  		if (np == dma_channel_np)
> >  			return ssi_np;
> > +		of_node_put(np);
> >  	}
> 
> Thanks for catching the problem, Julia, but the fix is not quite correct.  My
> code assumes that of_parse_phandle() doesn't claim the node, but it doesn't
> actually use the node pointer, either.  All I care about is whether 'np' is
> equal to dma_channel_np.  I'm not going to use 'np'.  So I think the real fix is
> this:
> 
> @@ -880,10 +880,12 @@ static struct device_node *find_ssi_node(struct
> device_node *dma_channel_np)
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
> 
>  	return NULL;

OK, that looks reasonable.

julia
