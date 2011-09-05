Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1IEPXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:23:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1IEPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:23:16 -0400
Date: Mon, 5 Sep 2011 17:23:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
In-Reply-To: <1315235596.26251.201.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1109051722560.1112@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange> 
 <1314282386.1606.42.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
  <1314283286.1606.52.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
  <1314292850.1606.88.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
  <1314619909.1606.130.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108291419410.31184@axis700.grange>
  <1314622113.1606.134.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108300906590.19151@axis700.grange>
  <1314698257.1606.159.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108301321500.19151@axis700.grange>
  <Pine.LNX.4.64.1109051007230.1112@axis700.grange>  <1315227964.26251.68.camel@vkoul-udesk3>
 <1315235596.26251.201.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:u6ZMn2jQY3MV7vfzYgOS2xq+5IRaKlVCUJizIfZlVlK
 KL6LjQW7RMMPUYMXTpmc2RbOQ3RB1n2u/FmiTLuT6tahYqPtIv
 H4IAr/JCrx6ecbgYFpYCug7QxBtHATvB4s769MLsJM/kuTCOtt
 LDDkZxj7q0Kew4rD5IO650KlXLB+6lYzh8eO1UAwalDGgTOyjE
 a1yug3XcoUXVfOWTQFfO/CPrWpkHKxHjCCBljTrl2AKj1wqaLL
 0doWXzLqhrswLQLicoxtIxNjO7VvmvwoKgFkuA1NkGHqYEAMDM
 YPpSSzhZM/g9uGMjols3FZ9iH/61MzlIqsVPsPhJwHEFh0gwut
 i4BO81JcoGwPSLHlp5xzUVdtfYObmvXHa0jGu63CoJwgcpi6t/
 AXwumngB9LGuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011, Vinod Koul wrote:

> On Mon, 2011-09-05 at 18:36 +0530, Vinod Koul wrote:
> > On Mon, 2011-09-05 at 10:10 +0200, Guennadi Liakhovetski wrote:
> > > Hi Vinod
> > > 
> > > On Tue, 30 Aug 2011, Guennadi Liakhovetski wrote:
> > Please dont top post...
> > > > Sorry, I see it differently. I don't use any counters in my patch. I'm 
> > > > only checking for empty queue, i.e., I'm just identifying the first 
> > > > descriptor submission and the last completion or termination.
> > > > 
> > > > > You juts need
> > > > > to call _put/_get at right places, which IMO l;ooks lot simpler than
> > > > > current approach
> > > > 
> > > > If we didn't have to check for exact symmetry, then yes, I agree, this 
> > > > would be cleaner. I.e., if we indeed had well-defined entry- and 
> > > > exit-points, which are guaranteed to be called exact same number of times. 
> > > > Like, e.g., with file open() / close() etc. But since we don't have this 
> > > > symmetry, and instead have to add flags and iterate lists, this doesn't 
> > > > look natural and simple to me anymore, sorry.
> > > 
> > > What about this one? Would you be prepared to take it as is, or you still 
> > > think, that a pm_runtime_get*() on each descriptor submission would be 
> > > better?
> > I think I will go with your current approach. Let me review again and
> > check it. If I get time it should be in my tree by tonight
> This patch fails to apply for me, can you please rebase it to me tree
> and resend, I will apply it later this week

Sure, will do.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
