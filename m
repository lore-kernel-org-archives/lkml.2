Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab0KOSUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:20:53 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39503 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab0KOSUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:20:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6168"; a="62930436"
Subject: Re: [PATCH 09/14] msm: iommu: Kconfig option for cacheable page 
 tables
From: Daniel Walker <dwalker@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <8bd62d321211c93af883cd2ad404e802.squirrel@www.codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
	 <1289619000-13167-10-git-send-email-stepanm@codeaurora.org>
	 <1289765858.24270.240.camel@m0nster>
	 <8bd62d321211c93af883cd2ad404e802.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 10:20:36 -0800
Message-ID: <1289845236.4050.25.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 18:56 -0800, Stepan Moskovchenko wrote:
> > On Fri, 2010-11-12 at 19:29 -0800, Stepan Moskovchenko wrote:
> >>
> >> +config IOMMU_PGTABLES_L2
> >> +	depends on ARCH_MSM8X60
> >> +	depends on MMU
> >> +	depends on CPU_DCACHE_DISABLE=n
> >> +	depends on SMP
> >> +	bool "Cacheable IOMMU page tables"
> >> +	default y
> >> +	help
> >> +	  Allows the IOMMU page tables to be brought into the L2 cache. This
> >> +	  improves the TLB miss latency at the expense of potential pollution
> >> +	  of the L2 cache. This option has been shown to improve multimedia
> >> +	  performance in some cases.
> >> +
> >> +	  If unsure, say Y here.
> >
> > Why would someone want this off?
> >
> > The other thing is that you usually want this included with the code
> > that uses the option.
> 
> The code that uses it had gone in during a previous patch series, but I
> didn't want to meddle in the Kconfig just yet, especially since the option
> only improves performance and does not add new functionality at a high
> level. This patch should be the last of what is needed for this feature.
> 
> You would want to turn this off if you wanted more deterministic behavior
> from the multimedia subsystem, such as when trying to run benchmarks for
> the worst-case behavior in terms of memory latency and TLB misses. You
> might also want to turn it off if you are debugging memory problems that
> you suspect might be related to the cache maintenance code, in which case
> turning this off would give an idea as to whether that is the problem.
> Similarly, this needs to be off (and will be, due to the dependencies) if
> certain required things (like the Dcache, MMU, etc) have been disabled.
> Finally, if you are doing things with the MMSS that you know will not
> result in many TLB misses, (or if you know that you can tolerate high miss
> latency) you may as well turn this off to avoid the (small) bit of cache
> pollution.

It sounds like you don't really want it off unless your a developer (or
you turn one of the dependencies) .. I think this might be better as a
hidden option just cause of the developer centric nature of it.

Daniel


-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

