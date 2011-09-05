Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1IENIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:08:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:27597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab1IENIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45371194"
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1109051007230.1112@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange>
	 <1314282386.1606.42.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
	 <1314283286.1606.52.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
	 <1314292850.1606.88.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
	 <1314619909.1606.130.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108291419410.31184@axis700.grange>
	 <1314622113.1606.134.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108300906590.19151@axis700.grange>
	 <1314698257.1606.159.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108301321500.19151@axis700.grange>
	 <Pine.LNX.4.64.1109051007230.1112@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 18:36:04 +0530
Message-ID: <1315227964.26251.68.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-05 at 10:10 +0200, Guennadi Liakhovetski wrote:
> Hi Vinod
> 
> On Tue, 30 Aug 2011, Guennadi Liakhovetski wrote:
Please dont top post...
> > Sorry, I see it differently. I don't use any counters in my patch. I'm 
> > only checking for empty queue, i.e., I'm just identifying the first 
> > descriptor submission and the last completion or termination.
> > 
> > > You juts need
> > > to call _put/_get at right places, which IMO l;ooks lot simpler than
> > > current approach
> > 
> > If we didn't have to check for exact symmetry, then yes, I agree, this 
> > would be cleaner. I.e., if we indeed had well-defined entry- and 
> > exit-points, which are guaranteed to be called exact same number of times. 
> > Like, e.g., with file open() / close() etc. But since we don't have this 
> > symmetry, and instead have to add flags and iterate lists, this doesn't 
> > look natural and simple to me anymore, sorry.
> 
> What about this one? Would you be prepared to take it as is, or you still 
> think, that a pm_runtime_get*() on each descriptor submission would be 
> better?
I think I will go with your current approach. Let me review again and
check it. If I get time it should be in my tree by tonight

-- 
~Vinod

