Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1CQP0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:26:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50067 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1CQP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:26:00 -0400
Date: Thu, 17 Mar 2011 16:25:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110317152559.GG11094@one.firstfloor.org>
References: <4D817234.9070106@jp.fujitsu.com> <4D8172D7.3040201@jp.fujitsu.com> <20110317041424.GD11094@one.firstfloor.org> <4D819A2A.8050606@jp.fujitsu.com> <20110317062612.GE11094@one.firstfloor.org> <4D81BB87.10803@jp.fujitsu.com> <20110317140401.GX10696@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317140401.GX10696@random.random>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> isn't 100% correct and probably it's impossible to make it 100%
> correct across the whole kernel (for example the compound_head is safe
> for THP but it's still unsafe for hugetlbfs while the page is being
> tear down), so it's probably ok that it tends to work in practice 100%

I would like to fix known oopses in the existing paths, so that should
be probably fixed. 

> reliably when the task is running in userland but we leave holes when
> kernel is mangling the page structures and moving stuff around,
> otherwise we litter the kernel code without much practical benefit, I
> guess KSM has the same issues of khugepaged for example.

We measured KSM some time ago on some simple workloads (a couple
of window guests) and it turned out that KSM memory tends to be 
only a very small fraction of total physical memory. So it was
deemed not very important for hwpoison.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
