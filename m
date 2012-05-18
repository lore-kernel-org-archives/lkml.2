Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab2ERIW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:22:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760331Ab2ERIVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:21:40 -0400
Date: Fri, 18 May 2012 10:21:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/9 v3] dma: shdma: prepare for conversion to the shdma
 base library
In-Reply-To: <1337055832.16185.5362.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1205181017250.23140@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de> 
 <1336576161-27082-3-git-send-email-g.liakhovetski@gmx.de>
 <1337055832.16185.5362.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:5wJSPp19+VuOUSsRayV/4J2FBA1cOXvMznoMudB/83i
 WajcccFHATN8M39jTC+W3dvKIPk47dxqPuXaqfPUA/0GBZCFd2
 FPh23ktxT1iU+zeJqjc21enhkhLokFlBzTFv+++FkiOHOm/i1m
 1QbT0WXpnhuIUSiXtp5TtPDwozChdBy/O1LtIGaQ7aeL7xojAy
 lDoMNNLbjYGI/q9eknRyWZRywQLb4hQiqIr3eVii6Vzhl1PEoy
 EaG1gHuT0sOlxxujO37zFa9DTNwYyGSHgMM34N1h9LP8t702Nc
 nIMJTat6XjiZOJZUW7Q9TFvlgHxt54BSQ9QyeU6rnznc+G/377
 IVzw00KETU5hk5bWYhv/VXGnQRpe2yEQjlNkgmpk/u3Oni5L3w
 xSjOs5IrH59Ig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Vinod Koul wrote:

> On Wed, 2012-05-09 at 17:09 +0200, Guennadi Liakhovetski wrote:
> > By placing an anonymous union at the top of struct sh_dmae_slave we can
> > transparently prepare all device and client drivers for the upcoming
> > shdma-base conversion.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  include/linux/sh_dma.h |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
> > index 425450b..e081e8e 100644
> > --- a/include/linux/sh_dma.h
> > +++ b/include/linux/sh_dma.h
> > @@ -10,12 +10,16 @@
> >  #ifndef SH_DMA_H
> >  #define SH_DMA_H
> >  
> > -#include <linux/list.h>
> >  #include <linux/dmaengine.h>
> > +#include <linux/list.h>
> > +#include <linux/shdma-base.h>
> >  
> >  /* Used by slave DMA clients to request DMA to/from a specific peripheral */
> >  struct sh_dmae_slave {
> > -	unsigned int			slave_id; /* Set by the platform */
> > +	union {
> > +		unsigned int		slave_id; /* Set by the platform */
> > +		struct shdma_slave	shdma_slave;
> again, this should be move to dma_slave_config

Same reasoning as in patch 1: I think such changes should be done 
separately.

> > +	};
> >  	struct device			*dma_dev; /* Set by the platform */
> >  	const struct sh_dmae_slave_config	*config;  /* Set by the driver */
> >  };

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
