Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1IEPLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:11:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:31982 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab1IEPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:11:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,333,1312182000"; 
   d="scan'208";a="45715242"
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
In-Reply-To: <Pine.LNX.4.64.1109051700030.1112@axis700.grange>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange>
	 <1308916071.1536.4.camel@vkoul-udesk3>
	 <20110829080047.GJ31809@linux-sh.org>
	 <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com>
	 <1314618931.1606.114.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
	 <1314698522.1606.164.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
	 <1314703426.1606.167.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108301332190.19151@axis700.grange>
	 <Pine.LNX.4.64.1109051002400.1112@axis700.grange>
	 <1315228408.26251.75.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109051532220.1112@axis700.grange>
	 <1315233788.26251.163.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109051700030.1112@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 20:38:55 +0530
Message-ID: <1315235335.26251.194.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-05 at 17:01 +0200, Guennadi Liakhovetski wrote:
> On Mon, 5 Sep 2011, Vinod Koul wrote:
> 
> > On Mon, 2011-09-05 at 15:48 +0200, Guennadi Liakhovetski wrote:
> > > 
> > > Let me try again. DMA channels on these DMA controllers are not dedicated. 
> > > On one such SoC there can be several such DMA controllers of different 
> > > kinds. One kind is "generic" - it can do memcpy(), besides channels can be 
> > > freely configured for one of onboard peripherals: serial, mmc, etc. Some 
> > > of them can also serve external DMA-capable devices. Another kind of DMA 
> > > controllers, served by the same driver, can only be used with USB 
> > > controllers. Now, if the MMC driver requests a DMA channel, let's say, the 
> > > dmaengine core first finds the USB DMA controller. The MMC driver cannot 
> > > know this. It assigns its MMC DMA configuration to the.private pointer and 
> > > returns true. Next the DMA driver is entered, it checks the private 
> > > pointer, sees an MMC channel request, looks at the DMA controller and 
> > > sees, that it doesn't support MMC. So, .device_alloc_chan_resources() 
> > > fails. When the same is attempted with a suitable DMA controller, the 
> > > shdma driver recognises, that the controller can service MMC and uses the 
> > > data, provided the MMC driver, to configure the DMA channel for MMC.
> > Hmmm, Can't you know in filter function if the respective channel can do
> > the dma for you or not? Maybe export a dma function or use platform data
> > for this (wont you soc have these caps fixed), i prefer latter.
> > That maybe a better approach. 
> 
> How? On a system you can have 3 suitable DMA controllers and 2 unsuitable. 
> Do you want to pass a list of 3 suitable DMA controllers to each 
> peripheral driver?...
The peripheral driver (client driver in slave-dma terminology) should
already know which dmac it wants. (base on information in platform data
etc) That is why the filter function is provided. Please use it properly
Other soc have similar capabilities and they can filter properly so why
cant you..?

-- 
~Vinod

PS: This might well be my last post before Tue EOD PST, traveling to
LPC, if you are there feel free to chat with me on this.

