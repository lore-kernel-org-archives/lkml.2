Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031329Ab2CSOSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:18:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:61345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030558Ab2CSOR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:17:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="119126633"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1203191502170.11516@axis700.grange>
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
	 <1332164062.7180.19.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203191436030.11516@axis700.grange>
	 <1332165604.7180.24.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203191502170.11516@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 19:52:18 +0530
Message-ID: <1332166938.7180.38.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 15:09 +0100, Guennadi Liakhovetski wrote:
> YES! This is exactly what I am talking about! We need an additional 
> parameter to dma_request_channel(). Whereas in the discussion, that you 
> pointed me to, it still had the same 3 parameters, as now. (Maybe this has 
> already been decided upon before - to add an additional parameter, not 
> sure anymore, this thread has become too long and too slow... My apologies 
> in this case) So, this can be a device pointer or some specialised slave 
> ID. Device pointer is nice, I agree. And the next change, that I'd like to 
> request is pass this parameter further on to DMA device driver's 
> .device_alloc_chan_resources() method. 
Sorry my bad. I confused your request for additional parameter as
request for adding slave_config etc stuff into request API.

Yes this API would need to be modified for telling dmaengine about
client. Now Given that this is more slave stuff, I have leaning to
adding a slave specific request api, something like
dmaengine_request_slave_channel() which is used for our purpose while
keeping the original API intact for async_tx usages.

Btw why should .device_alloc_chan_resources() need this, I so no reason,
unless we are working around some other issue.

-- 
~Vinod

