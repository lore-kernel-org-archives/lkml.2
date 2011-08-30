Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1H3LZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:25:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:40539 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1H3LZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="43325117"
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
In-Reply-To: <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange>
	 <1308916071.1536.4.camel@vkoul-udesk3>
	 <20110829080047.GJ31809@linux-sh.org>
	 <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com>
	 <1314618931.1606.114.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
	 <1314698522.1606.164.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 16:53:46 +0530
Message-ID: <1314703426.1606.167.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 13:20 +0200, Guennadi Liakhovetski wrote:
> On Tue, 30 Aug 2011, Vinod Koul wrote:
> 
> > On Tue, 2011-08-30 at 09:54 +0200, Guennadi Liakhovetski wrote:
> > > On Mon, 29 Aug 2011, Vinod Koul wrote:
> > > > > >> You should not assign chan->private.
> > > > > >> Please move this  to dma_slave_control API
> > > > > >
> > > > > > I haven't seen any reply to this comment and this patch seems to still be
> > > > > > outstanding, is there an updated version of this patch that I've missed?
> > > > I don't recall seeing any updated version fixing this 
> > > 
> > > As a matter of fact, when you say "use dma_slave_control API," you 
> > > actually mean the dma_slave_config, right? Then, how is one supposed to 
> > > use it in this case? Shall we be issuing a DMA_SLAVE_CONFIG call inside of 
> > > the filter and check the return code? The problem is, that not all DMA 
> > > controllers on sh-mobile SoCs can service the same slave devices. So, if 
> > > we don't check in the filter we might well get an unsuitable DMA channel.
> > Here you are assigning to chan->private your specific values, which
> > should be moved to the dma_slave_config. 
> > But here you are removing the checks, and accepting the first channel
> > you got, so how do you find channel is suitable or not.
> 
> That's done in the driver's .device_alloc_chan_resources() method. It 
> checkx the .private pointer, tries to find a suitable channel, if it fails 
> - it returns -EINVAL. See 
> drivers/dma/shdma.c::sh_dmae_alloc_chan_resources():
> 
> 	if (param) {
> 		const struct sh_dmae_slave_config *cfg;
> 
> 		cfg = sh_dmae_find_slave(sh_chan, param);
> 		if (!cfg) {
> 			ret = -EINVAL;
> 			goto efindslave;
> 		}
Now am doubly confused. Are you saying that you are using
alloc_chan_resources for doing filtering??

-- 
~Vinod

