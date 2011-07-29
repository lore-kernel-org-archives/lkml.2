Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1G2NQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:16:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:47829 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061Ab1G2NQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:16:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="33000259"
Subject: Re: [PATCH 10/18] dmaengine/amba-pl08x: Get rid of
 pl08x_pre_boundary()
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>, linus.walleij@linaro.org,
        pratyush.anand@st.com, rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com,
        shiraz.hashim@st.com, linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110729110525.GG25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com>
	 <c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
	 <20110729110525.GG25640@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 18:02:57 +0530
Message-ID: <1311942777.1536.547.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 12:05 +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 29, 2011 at 04:19:20PM +0530, Viresh Kumar wrote:
> > Pl080 Manual says: "Bursts do not cross the 1KB address boundary"
> > 
> > We can program the controller to cross 1 KB boundary on a burst and controller
> > can take care of this boundary condition by itself.
> > 
> > Following is the discussion with ARM Technical Support Guys (David):
> > [Viresh] Manual says: "Bursts do not cross the 1KB address boundary"
> > 
> > What does that actually mean? As, Maximum size transferable with a single LLI is
> > 4095 * 4 =16380 ~ 16KB. So, if we don't have src/dest address aligned to burst
> > size, we can't use this big of an LLI.
> > 
> > [David] There is a difference between bursts describing the total data
> > transferred by the DMA controller and AHB bursts. Bursts described by the
> > programmable parameters in the PL080 have no direct connection with the bursts
> > that are seen on the AHB bus.
> > 
> > The statement that "Bursts do not cross the 1KB address boundary" in the TRM is
> > referring to AHB bursts, where this limitation is a requirement of the AHB spec.
> > You can still issue bursts within the PL080 that are in excess o f 1KB. The
> > PL080 will make sure that its bursts are broken down into legal AHB bursts which
> > will be formatted to ensure that no AHB burst crosses a 1KB boundary.
> > 
> > Based on above discussion, this patch removes all code related to 1 KB boundary
> > as we are not required to handle this in driver.
> 
> Good.  I'm glad someone's finally getting to the bottom of what's
> actually required and what isn't...  This driver has been a mess for
> quite a long time and is in desperate need of these kinds of cleanups.
Typically in few dmac IPs i know of:
There is max limitation of what a burst length can be for dma, and what
a max transfer length can be.
The dma will push/pull data into peripheral FIFO based on
max_burst_length parameter (note length in dma terminology is always
items not bytes, and one item is usually defined as
transfer_length/src_width). For a transfer (single block or in
multi-block) the dmac will break the transaction into multiple bursts
and based on max_burst_length it will push/pull data to/from FIFO. Also
matching FIFO thresholds with max_burst_length is also important and can
be tuned based on perf/power requirements. 

Sharing my knowledge, hopefully it helps :)

-- 
~Vinod

