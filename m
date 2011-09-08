Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1IHXdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:33:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:55603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1IHXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:33:12 -0400
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
From: Vinod Koul <vkoul@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: vinod.koul@intel.com, "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>
In-Reply-To: <20110908012119.GJ22142@linux-sh.org>
References: <Pine.LNX.4.64.1109051002400.1112@axis700.grange>
	 <1315228408.26251.75.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109051532220.1112@axis700.grange>
	 <1315233788.26251.163.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109051700030.1112@axis700.grange>
	 <1315235335.26251.194.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1109051716530.1112@axis700.grange>
	 <438BB0150E931F4B9CE701519A4463010871804A4B@bgsmsx502.gar.corp.intel.com>
	 <alpine.DEB.2.00.1109072048310.30407@axis700.grange>
	 <438BB0150E931F4B9CE701519A4463010871804A4F@bgsmsx502.gar.corp.intel.com>
	 <20110908012119.GJ22142@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 01:01:03 +0530
Message-ID: <1315510263.26251.296.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 10:21 +0900, Paul Mundt wrote:
> On Thu, Sep 08, 2011 at 03:07:53AM +0530, Koul, Vinod wrote:
> > On Wed, 2011-09-07 at 22:01 +0200, Guennadi Liakhovetski wrote:
> > > On Thu, 8 Sep 2011, Koul, Vinod wrote:
> > > You're seriously suggesting to export and use an additional shdma private 
> > > function, bypassing the dmaengine API?... That really doesn't sound like a 
> > > good idea to me, sorry. How about using .device_control(DMA_SLAVE_CONFIG) 
> > > from the filter function directly to verify channel suitability?
> > Yes see stedma40, coh90138 drivers
> > .device_control is not right place as channel is already allocated.
> > 
> 
> No, that's not going to happen either. Many of these drivers are used in
> different CPUs with different DMACs. The dmaengine driver in question
> only applies to a subset, so the driver bits need to be wholly generic.
> In short, if the dmaengine API can't handle this sort of stuff then it's
> the dmaengine API that needs to be extended, we won't be working around
> dmaengine shortcomings in drivers that simply want a sensible DMA API to
> plug in to.The only thing lacking in dmaengine API is proper filtering for slave
usages where channel/controller is matches to specfic dmac slave.

There was a proposal by Linux W, and Jassi Brar for solving this
problem, and I think that should solve above problem.

I relooked at the patch, since the filtering is already done in
your .alloc_chan_resources, (which should be fixed when we fix
filtering), I am going to apply this patch


