Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2CIJQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:16:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:13515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2CIJQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:16:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="116156798"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1203081412550.29847@axis700.grange>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Mar 2012 14:51:58 +0530
Message-ID: <1331284918.4657.69.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 14:18 +0100, Guennadi Liakhovetski wrote:
> > Assuming I didn't miss...
> > 
> > The case B can be handled without sweat by platforms channel mapping
> > information.
> > 
> > Case A where we don't find that devices exist in map, thus being treated
> > as generic DMA channels and can be handled easily in sequence. So when
> > someone in Q request a channel it would get first channel in Ps
> > 
> > This way we handle both of them in a transparent manner to both clients
> > and controllers. 
> > 
> > Perhaps we can also add capability to know that if channel is to be
> > searched in map or not - would be anyway required for non slave cases.
> 
> Right, but I don't understand then what this gives us. You propose some 
> channel maps, that will not be used for your "case A." Which means, for 
> "case A" nothing changes. So, the reason for this whole thread hasn't been 
> addressed: how to pass channel configuration to the DMA controller driver.
For "Case A" there should be no filtering or any issues even now. You
have controller requesting a channel and as long as they get a channel
for respective pool, it should work.

Or is there anything else which is required in this case?


-- 
~Vinod

