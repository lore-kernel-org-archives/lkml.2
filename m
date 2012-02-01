Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2BAFm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:42:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:49517 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab2BAFm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:42:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112691760"
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
In-Reply-To: <Pine.LNX.4.64.1202010022310.31226@axis700.grange>
References: <1327612946-29397-1-git-send-email-alexandre.bounine@idt.com>
	 <1327915849.1527.17.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1202010022310.31226@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Feb 2012 11:13:23 +0530
Message-ID: <1328075003.1610.6.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 01:09 +0100, Guennadi Liakhovetski wrote:
> On Mon, 30 Jan 2012, Vinod Koul wrote:
> 
> > On Thu, 2012-01-26 at 16:22 -0500, Alexandre Bounine wrote:
> > > As we agreed during our discussion about adding DMA Engine support for RapidIO
> > > subsystem, RapidIO and similar clients may benefit from adding an extra context
> > > parameter to device_prep_slave_sg() callback.
> > > See https://lkml.org/lkml/2011/10/24/275 for more details.
> > > 
> > > Adding the context parameter will allow to pass client/target specific
> > > information associated with an individual data transfer request.
> > > 
> > > In the case of RapidIO support this additional information consists of target
> > > destination ID and its buffer address (which is not mapped into the local CPU
> > > memory space). Because a single RapidIO-capable DMA channel may queue data
> > > transfer requests to different target devices, the per-request configuration
> > > is required.
> > > 
> > > The proposed change eliminates need for new subsystem-specific API.
> > > Existing DMA_SLAVE clients will ignore the new parameter.
> > > 
> > > This RFC only demonstrates the API change and does not include corresponding
> > > changes to existing DMA_SLAVE clients. Complete set of patches will be provided
> > > after (if) this API change is accepted.
> > This looks good to me. But was thinking if we need to add this new
> > parameter for other slave calls (circular, interleaved, memcpy...)
> 
> Yes, we (shdma.c) also need to pass additional slave configuration 
> information to the dmaengine driver and I also was thinking about 
> extending the existing API, but my ideas were going more in the direction 
> of adding a parameter to __dma_request_channel() along the lines of
So your question is more on the lines of channel mapping/allocation?
The approach here is to pass controller specific parameters which are
required to setup the respective transfer. Since this is dependent on
each transfer, this needs to be passed in respective prepare.

The two things are completely orthogonal and shouldn't be clubbed.
For your issue we need a separate debate on how to solve this... I am
open to ideas...


-- 
~Vinod

