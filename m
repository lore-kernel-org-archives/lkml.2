Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2GPI2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:28:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:45301 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab2GPI2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168807161"
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
	 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
	 <1342418828.1726.37.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160832540.12302@axis700.grange>
	 <1342421587.1726.49.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1207160907180.12302@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jul 2012 13:58:25 +0530
Message-ID: <1342427305.1726.50.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 09:13 +0200, Guennadi Liakhovetski wrote:
> > > They tell the driver how the channel has to be configured to
> support this 
> > > specific client. They are values of two specific registers. In
> fact, CHCR 
> > > means exactly that - CHannel Control Register.
> > what exactly does the channel control register do in shdma? Should
> shdma
> > driver deduce this value rather than client giving it?
> > Same question for mid_rid?
> 
> See, e.g.,
> arch/arm/mach-shmobile/setup-sh7372.c::sh7372_dmae_slaves[]. 
> Platforms are supplying these values with shdma driver platform data, 
> together with slave IDs. Them when slaves request channels and supply 
> their slave IDs, the driver searches the above array, looking for the 
> matching slave ID, then it uses the rest of the information in those 
> structs to configure the channel for this client. Again, this is
> nothing 
> new, this is how the driver has been functioning since a long time,
> this 
> driver is not modifying anything there. Any changes to this
> procedure, 
> like providing all thig information from clients themselves instead
> of 
> keeping it with DMACs, requires these patches to be committed first.
That wasn't my question.

I want to know what does ccr and mid_rid mean to dmac here?

-- 
~Vinod

