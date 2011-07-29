Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1G2LFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:05:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50798 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1G2LFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:05:42 -0400
Date: Fri, 29 Jul 2011 12:05:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 10/18] dmaengine/amba-pl08x: Get rid of
	pl08x_pre_boundary()
Message-ID: <20110729110525.GG25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:19:20PM +0530, Viresh Kumar wrote:
> Pl080 Manual says: "Bursts do not cross the 1KB address boundary"
> 
> We can program the controller to cross 1 KB boundary on a burst and controller
> can take care of this boundary condition by itself.
> 
> Following is the discussion with ARM Technical Support Guys (David):
> [Viresh] Manual says: "Bursts do not cross the 1KB address boundary"
> 
> What does that actually mean? As, Maximum size transferable with a single LLI is
> 4095 * 4 =16380 ~ 16KB. So, if we don't have src/dest address aligned to burst
> size, we can't use this big of an LLI.
> 
> [David] There is a difference between bursts describing the total data
> transferred by the DMA controller and AHB bursts. Bursts described by the
> programmable parameters in the PL080 have no direct connection with the bursts
> that are seen on the AHB bus.
> 
> The statement that "Bursts do not cross the 1KB address boundary" in the TRM is
> referring to AHB bursts, where this limitation is a requirement of the AHB spec.
> You can still issue bursts within the PL080 that are in excess o f 1KB. The
> PL080 will make sure that its bursts are broken down into legal AHB bursts which
> will be formatted to ensure that no AHB burst crosses a 1KB boundary.
> 
> Based on above discussion, this patch removes all code related to 1 KB boundary
> as we are not required to handle this in driver.

Good.  I'm glad someone's finally getting to the bottom of what's
actually required and what isn't...  This driver has been a mess for
quite a long time and is in desperate need of these kinds of cleanups.
