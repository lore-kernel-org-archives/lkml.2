Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab2EYLAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:00:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2EYLAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:00:06 -0400
Date: Fri, 25 May 2012 12:59:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laxman Dewangan <ldewangan@nvidia.com>
cc: Vinod Koul <vinod.koul@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/9 v3] dmaengine: add an shdma-base library
In-Reply-To: <4FBF5EA9.704@nvidia.com>
Message-ID: <Pine.LNX.4.64.1205251255310.13353@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de> 
 <1336576161-27082-2-git-send-email-g.liakhovetski@gmx.de> 
 <1337055734.16185.5360.camel@vkoul-udesk3>  <Pine.LNX.4.64.1205171912140.10086@axis700.grange>
 <1337933737.1580.8.camel@vkoul-udesk3> <4FBF5EA9.704@nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:uRVTHpLqr3CaYKelJahLHAP6AejwuJFJnv5ALBrKM6k
 mnX+Ajac9Sm1pRPgNUbiyUCgIn1rtHvKhwJCQrRt7Owr8EUrDK
 OCNcCCoxa85WESZtrt6vHPWM8HLjaE8FarbKN12Pn5R6GaiJfa
 QS6x4pS1XKcfeS+7QIabbN6TBogdY/0V0g3GulLA1G+OclX+Oe
 JWI2JQTpxI3f8z8YuXsgyJqV9T0GSF9UDTtixM+53tHC8eJ955
 65ncF1a1zXGRc7FvE9RpRW+4A7VjfIN8AmYK+CmSSA0jEJ+5ih
 NYT9En1Ffp/x+b/vEsR0BaoRarNudnUhoTIe3hJgnLRFLUy335
 KqPKiPvycMR/lHSlz2AfTKPAr4n+B6RcgsFCTRgrdc9b3MpcUJ
 OuGpNhWOFTpDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman

On Fri, 25 May 2012, Laxman Dewangan wrote:

> On Friday 25 May 2012 01:45 PM, Vinod Koul wrote:
> > On Fri, 2012-05-18 at 10:21 +0200, Guennadi Liakhovetski wrote:
> 
> > +/*
> > > > > + * Drivers, using this library are expected to embed struct
> > > > > shdma_dev,
> > > > > + * struct shdma_chan, struct shdma_desc, and struct shdma_slave
> > > > > + * in their respective device, channel, descriptor and slave objects.
> > > > > + */
> > > > > +
> > > > > +struct shdma_slave {
> > > > > +	unsigned int slave_id;
> > > > this should be moved to struct dma_slave_config
> > > Again, this would be a functional change. And struct dma_slave_config
> > > doesn't have a slave-ID field in it, which is the only thing we need for
> > > now. Instead it has a bunch of other fields, of which none is so far used
> > > by this driver.
> > > 
> 
> In Nvidia's tegra SOC also require to pass the slave id from client to dma
> driver. I have pushed the change to make it part of struct dma_slave_config
> on the patch
> [PATCH V4 1/2] dma: dmaengine: add slave req id in slave_config
> 
> So hope you can use the same if that patch get merged.

Thanks for letting me know. After both our series get merged, when working 
on removal of .private use, switching to your new .slave_id will really be 
the way to go for us.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
