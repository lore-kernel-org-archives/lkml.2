Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab1EBJxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:53:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab1EBJxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:53:17 -0400
Date: Mon, 2 May 2011 11:53:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Koul, Vinod" <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH 2/2] dmaengine: shdma: add runtime- and system-level
 power management
In-Reply-To: <1304325486.1589.15.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1105021117060.13244@axis700.grange>
References: <Pine.LNX.4.64.1104291901200.17813@axis700.grange> 
 <Pine.LNX.4.64.1104291908090.17813@axis700.grange>  <1304323391.1589.9.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1105021056231.13244@axis700.grange> <1304325486.1589.15.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:A3s5WNPj6JWXiknMr68kf5e/y2xXTO02ddixrghLtAR
 d639CEt4xwQ6vEj8IvcyD8fvss5JUFJpGQAVvXzZ2K7gbw/kcF
 4AlXVO3mkfYPMipsf5/ygLXfWZHvRrwVxxJR/hJbDwL0gt8jdq
 EtDda4VZfs62bkoklwulBJMuz3r6cjc22qUHvWP+y+U8dJTY2N
 yItA8gYcp/05C5HqruFWitTB5O2SUMsrdHwNP3ho/w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Koul, Vinod wrote:

> On Mon, 2011-05-02 at 11:04 +0200, Guennadi Liakhovetski wrote:
> > On Mon, 2 May 2011, Koul, Vinod wrote:
> > 
> > > On Fri, 2011-04-29 at 19:09 +0200, Guennadi Liakhovetski wrote:
> > > > This patch extends and fixes runtime power management in the shdma
> > > > driver to support powering down the DMA controller and adds support
> > > > for system-level suspend and resume.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > ---
> > > >  drivers/dma/shdma.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  drivers/dma/shdma.h |    1 +
> > > >  2 files changed, 69 insertions(+), 0 deletions(-)
> > > > 
> > > 
> > > >  
> > > > +static int sh_dmae_runtime_suspend(struct device *dev)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > Don't you need to initialize you device on resume...????
> > 
> > Hm, yes, but this is suspend... Resume is below. Sorry, I probably don't 
> > understand your question.
> Opps, my question was for empty suspend. Dont you need to power off you
> device.

Powering down and up is performed by platform / domain hooks. I only need 
to reset the hardware on wakeup. An empty .runtime_suspend() is needed by 
the sh-mobile specific rtpm, at least by the version, that I have, because 
otherwise the device status will not be changed and the resume will not be 
called.

> > > > +
> > > > +static int sh_dmae_runtime_resume(struct device *dev)
> > > > +{
> > > > +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> > > > +
> > > > +	return sh_dmae_rst(shdev);
> > > > +}
> > > > +
> > > > +#ifdef CONFIG_PM
> > > This should be removed...
> > 
> > You mean, these functions just won't be called, but this way we save a 
> > couple of bytes if PM is not set, don't we?
> I meant you dont need to have this, PM is usually part of core options
> which ppl enable nowadays. Do you run with PM disabled?

I actually do, but maybe that's not a very important argument. So, if the 
only difference is a couple of kilobytes in the kernel size, then maybe we 
can just keep it always enabled. There are no other side-efects to it, 
right?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
