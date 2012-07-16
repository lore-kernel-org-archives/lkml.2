Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2GPMrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:47:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2GPMrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:47:49 -0400
Date: Mon, 16 Jul 2012 14:47:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
In-Reply-To: <1342437179.1726.61.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1207161445470.18978@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de> 
 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de> 
 <1342418828.1726.37.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
  <1342421587.1726.49.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
  <1342427305.1726.50.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161040070.12302@axis700.grange>
  <1342431452.1726.54.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161155280.12302@axis700.grange>
  <1342434256.1726.57.camel@vkoul-udesk3>  <Pine.LNX.4.64.1207161249260.18978@axis700.grange>
 <1342437179.1726.61.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:1BPGp8Y+XF/y5jDiC/BqttNN849J4DQms9zCMBNj9zR
 mGxgXLMFt8MrLvI3pP1xwToLHiBBnvPBJ4TzuqVgDr5cvSfx0E
 Zy5R4mQ4YV1rM632O5JZr6ZmfI2/h+9qgSmt8iNx/7XotrcPfN
 YbBCcPv3p6xnrNEJ0TgzLcxgj1UoMGx8NPOraT0q8tQJCRurWt
 rznxFNNlIW0xlw9h2dv1mkUB8pAgYqzqktRv/LVo50tWBLVL2Z
 wlZFpixgpt6YY68w15M8ZbM8Zb+YASPy1WGfwdOnMK2mwqOTHi
 nKibdwl/WBP91QTUtLLKl+0g/U9iMYx6I1SAJygrLZdV+qgfeS
 lsnQwBzrAJAGOojToBWS2GruTSqSVZEfUjGTfdFD3UVvKCgqRe
 UkcaFxGtpv/Uw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Vinod Koul wrote:

> On Mon, 2012-07-16 at 12:55 +0200, Guennadi Liakhovetski wrote:
> > On Mon, 16 Jul 2012, Vinod Koul wrote:
> > 
> > > On Mon, 2012-07-16 at 12:01 +0200, Guennadi Liakhovetski wrote:
> > > > On Mon, 16 Jul 2012, Vinod Koul wrote:
> > > > 
> > > > > On Mon, 2012-07-16 at 10:47 +0200, Guennadi Liakhovetski wrote:
> > > > > > > I want to know what does ccr and mid_rid mean to dmac here?
> > > > > > 
> > > > > > CHCR contains a few fields, some enable various interrupt sources, some 
> > > > > > specify repeat- and renew-modes, others yet specify transfer size, source 
> > > > > > and destination address-modes (incrementing, constant, decrementing), 
> > > > > > others yet select a DMA client category (slave / memcpy / ...), and a 
> > > > > > transfer flag. Some of these fields could be calculated, others are 
> > > > > > pre-defined for various slaves, the exact layout of those fields can also 
> > > > > > vary between SoCs.
> > > > > I do not understand how clients would provide these values. 
> > > > > For pre-defined values, they should be dmac property why should client
> > > > > like spi or mmc have clue about it?
> > > > > 
> > > > > For others like you mentioned, i guess they could be easily calculated,
> > > > > right?
> > > > > 
> > > > > > MID_RID is actually a slave-selector, it contains a magic value, that 
> > > > > > cannot be calculated. 
> > > > > and again, how does client know this?
> > > > 
> > > > I might be misunderstanding you, but from earlier discussions I got an 
> > > > impression, that the DMAC should know nothing about clients, i.e., should 
> > > > receive no client-specific information from its platform data. Instead 
> > > > clients should provide it when configuring the channel. If this is 
> > > > correct, then the preferred way would be to specify these values in client 
> > > > platform data and then pass it to the DMAC with slave-config calls? Or 
> > > > have I misunderstood you and this per-client information should be kept in 
> > > > DMAC platform data?
> > > You haven't misunderstood me. dmacs should not know of client data and
> > > should be client agnostic. 
> > > 
> > > BUT, are these parameters ccr and mid_rid client data, i do not think
> > > so, they seem to be dmac controller parameters which you need to
> > > configure channel or is that not the case. If not why bother passing
> > > them to dmac?
> > 
> > Yes, that's right - these values have to be written to DMAC channel 
> > configuration registers, so, we do not have to change anything, those 
> > values can remain DMAC parameters and be passed to it directly from 
> > platform data.
> Can you get that in future fixes.

Sorry, what exactly would you like to have fixed here? Above I just 
described how the driver already functions, what changes do you see 
necessary?

> > > Either way something looks fishy to me.
> > 
> > You can always tell me what you don't like about the driver, but I don't 
> > see why this specific patch should cause any problem - it only changes the 
> > type of the slave-id variable from unsigned to signed to be able to pass 
> > negative error values in it too.
> This question was not specific to this patchset
> 
> Btw I am quite happy with this patchset. Good direction for this and
> thanks for taking it up.

Thanks! That's very good to know!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
