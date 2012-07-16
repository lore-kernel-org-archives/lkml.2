Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2GPIrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:47:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2GPIrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:47:51 -0400
Date: Mon, 16 Jul 2012 10:47:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
In-Reply-To: <1342427305.1726.50.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1207161040070.12302@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de> 
 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de> 
 <1342418828.1726.37.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
  <1342421587.1726.49.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
 <1342427305.1726.50.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Z65sz3bIJyN7aAHVAHfrXXvPzlc0nV67XwmN0JGHHYo
 b749thMhUE7DeW2g8UrV9K6F/pdhT16nzBpSUasL7edDPDgACJ
 n5okTfuoH8Jx2Ok43oQQQwl93zU6WnkYLjHHt02RQjUdrwujrP
 YKWw+NN4cUK80Eo3uMD2dkGNb0Vi9bSyYfnbmPUB3eTkm5/JJt
 GAYspI7MHGlh85E10Q3m4Pq49wOHp2ZcmPFy4c7ugkVgR7WAy6
 QmYiK3fM2QsSF5yp83mJ3x+jArRucPuAUGAOlki6KjXP3/Ju+y
 l78SDlj0DEXj+avAxS33qLlhvjKU00+Qpfrsbv+rs10kgmdLP1
 xBD2XyLg5XPr7k845akoZwY65Hi19ecQy/J9gxcNGUnMICCw2K
 dXomAH3K+y94A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Vinod Koul wrote:

> On Mon, 2012-07-16 at 09:13 +0200, Guennadi Liakhovetski wrote:
> > > > They tell the driver how the channel has to be configured to
> > support this 
> > > > specific client. They are values of two specific registers. In
> > fact, CHCR 
> > > > means exactly that - CHannel Control Register.
> > > what exactly does the channel control register do in shdma? Should
> > shdma
> > > driver deduce this value rather than client giving it?
> > > Same question for mid_rid?
> > 
> > See, e.g.,
> > arch/arm/mach-shmobile/setup-sh7372.c::sh7372_dmae_slaves[]. 
> > Platforms are supplying these values with shdma driver platform data, 
> > together with slave IDs. Them when slaves request channels and supply 
> > their slave IDs, the driver searches the above array, looking for the 
> > matching slave ID, then it uses the rest of the information in those 
> > structs to configure the channel for this client. Again, this is
> > nothing 
> > new, this is how the driver has been functioning since a long time,
> > this 
> > driver is not modifying anything there. Any changes to this
> > procedure, 
> > like providing all thig information from clients themselves instead
> > of 
> > keeping it with DMACs, requires these patches to be committed first.
> That wasn't my question.
> 
> I want to know what does ccr and mid_rid mean to dmac here?

CHCR contains a few fields, some enable various interrupt sources, some 
specify repeat- and renew-modes, others yet specify transfer size, source 
and destination address-modes (incrementing, constant, decrementing), 
others yet select a DMA client category (slave / memcpy / ...), and a 
transfer flag. Some of these fields could be calculated, others are 
pre-defined for various slaves, the exact layout of those fields can also 
vary between SoCs.

MID_RID is actually a slave-selector, it contains a magic value, that 
cannot be calculated.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
