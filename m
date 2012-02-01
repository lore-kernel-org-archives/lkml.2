Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2BAOip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:38:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:15866 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab2BAOio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:38:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="102697872"
Subject: Re: [RFC] dmaengine/dma_slave: add context parameter to
 prep_slave_sg callback
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dan.j.williams@intel.com, Jassi Brar <jaswinder.singh@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <Pine.LNX.4.64.1202011234180.24739@axis700.grange>
References: <1327612946-29397-1-git-send-email-alexandre.bounine@idt.com>
	 <1327915849.1527.17.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1202010022310.31226@axis700.grange>
	 <1328075003.1610.6.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1202011234180.24739@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Feb 2012 20:09:35 +0530
Message-ID: <1328107175.1610.32.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 12:58 +0100, Guennadi Liakhovetski wrote:
> > The two things are completely orthogonal and shouldn't be clubbed.
> > For your issue we need a separate debate on how to solve this... I am
> > open to ideas...
> 
> Well, I'm not sure whether they are necessarily always orthogonal, they 
> don't seem so in my case at least. We definitely can use our approach - 
> configure the channel during allocation. I _think_ we could also perform 
> the configuration on a per-transfer basis, during the prepare stage, as 
> this RFC is suggesting, but that definitely would require reworking the 
> driver somewhat and changing the concept. The current concept is a fixed 
> DMA channel allocation to slaves for as long as the slave is using DMA. 
> This is simpler, avoids some overhead during operation and fits well with 
> the dmaengine PRIVATE channel concept. So, given the choice, we would 
> prefer to perform the configuration during channel allocation.
> 
> Maybe there are cases, where the driver absolutely needs this additional 
> information during allocation, in which case my proposal would be the only 
> way to go for them.
what are you trying to address, sending controller specific information
at allocation or the channel allocation itself. I kind of sense both.
But apprach here is discussed is to pass paramters which are required
for each transfer, not static for a channel, hence the additional
controller specific parameter in respective prepare. 
> 
> I'll post an RFC soon - stay tuned:-) 
Patch is always the best idea :-)

-- 
~Vinod

