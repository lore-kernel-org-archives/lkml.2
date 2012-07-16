Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2GPKY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:24:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:36455 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab2GPKY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:24:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="172588886"
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1207161155280.12302@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
	 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
	 <1342418828.1726.37.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
	 <1342421587.1726.49.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
	 <1342427305.1726.50.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207161040070.12302@axis700.grange>
	 <1342431452.1726.54.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207161155280.12302@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jul 2012 15:54:16 +0530
Message-ID: <1342434256.1726.57.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 12:01 +0200, Guennadi Liakhovetski wrote:
> On Mon, 16 Jul 2012, Vinod Koul wrote:
> 
> > On Mon, 2012-07-16 at 10:47 +0200, Guennadi Liakhovetski wrote:
> > > > I want to know what does ccr and mid_rid mean to dmac here?
> > > 
> > > CHCR contains a few fields, some enable various interrupt sources, some 
> > > specify repeat- and renew-modes, others yet specify transfer size, source 
> > > and destination address-modes (incrementing, constant, decrementing), 
> > > others yet select a DMA client category (slave / memcpy / ...), and a 
> > > transfer flag. Some of these fields could be calculated, others are 
> > > pre-defined for various slaves, the exact layout of those fields can also 
> > > vary between SoCs.
> > I do not understand how clients would provide these values. 
> > For pre-defined values, they should be dmac property why should client
> > like spi or mmc have clue about it?
> > 
> > For others like you mentioned, i guess they could be easily calculated,
> > right?
> > 
> > > MID_RID is actually a slave-selector, it contains a magic value, that 
> > > cannot be calculated. 
> > and again, how does client know this?
> 
> I might be misunderstanding you, but from earlier discussions I got an 
> impression, that the DMAC should know nothing about clients, i.e., should 
> receive no client-specific information from its platform data. Instead 
> clients should provide it when configuring the channel. If this is 
> correct, then the preferred way would be to specify these values in client 
> platform data and then pass it to the DMAC with slave-config calls? Or 
> have I misunderstood you and this per-client information should be kept in 
> DMAC platform data?
You haven't misunderstood me. dmacs should not know of client data and
should be client agnostic. 

BUT, are these parameters ccr and mid_rid client data, i do not think
so, they seem to be dmac controller parameters which you need to
configure channel or is that not the case. If not why bother passing
them to dmac?

Either way something looks fishy to me.
> 
> I.e., in both cases magic values are provided by platforms, the only 
> difference is - either keep them in DMAC platform data or move them in 
> each individual DMA client platform data.
> 
> Yes, some CHCR fields can be calculated, but location and width of those 
> fields might vary between DMAC versions, so, they will have to be passed 
> with DMAC platform data. But this definitely can be done in the future.


-- 
~Vinod

