Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab2CSNaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:30:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:61480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757738Ab2CSNaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:30:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120610096"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1203191244240.11516@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	 <20120307093026.GM17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	 <20120307103112.GP17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
	 <20120307124620.GT17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
	 <20120307142634.GA18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
	 <20120307162755.GB18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
	 <1331188201.4657.51.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
	 <1331204128.4657.54.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
	 <1331206459.4657.59.camel@vkoul-udesk3>
	 <1331211513.4657.67.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203081412550.29847@axis700.grange>
	 <1331284918.4657.69.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
	 <1331285959.4657.76.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203091049060.7852@axis700.grange>
	 <1331520476.4657.79.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203161029490.13465@axis700.grange>
	 <1332157021.7180.5.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203191244240.11516@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 19:04:22 +0530
Message-ID: <1332164062.7180.19.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 12:47 +0100, Guennadi Liakhovetski wrote:
> As I wrote in a reply to Linus W - you need to pass information about the 
> requesting client to the dmaengine core to let it match it against mapping 
> tables. 
NO. 
The client only needs to say that he needs a channel for DMA_SLAVE
DMAengine will know for this client, the platform channel map (already
given to it by platform) says that we can give it DMAC X, channel 4
only. So see if it free, if so allocate it and give to client (while
doing usual stuff)
> You have to pass this information with the dma_request_channel() 
> function. So, either you need to add a parameter or you have to reuse one 
> of existing ones, e.g., deprecate the filter and use its argument for this 
> purpose. If you do this and as long as you pass that parameter further on 
> to the dmaengine device (controller) driver after whatever matching you 
> like to do in the core - I'm fine with that, that fits well with my 
> initial proposal.
I don't care about filter, it can go away if it is not required.

Passing slave_config is *enhancement* so for (hopefully) last time
 a) it has *nothing* to do with getting a channel, no role to play in
generic scheme of things
 b) it allows client to call one api for get+configure thats all! 

-- 
~Vinod

