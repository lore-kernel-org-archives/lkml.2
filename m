Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1JMP75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:59:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:27787 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780Ab1JMP74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:59:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,340,1315206000"; 
   d="scan'208";a="73278734"
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in __vm_enough_memory
References: <20111012160202.GA18666@sgi.com>
	<20111012120118.e948f40a.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1110121452220.31218@router.home>
	<20111013150642.GC6169@csn.ul.ie>
Date: Thu, 13 Oct 2011 08:59:49 -0700
In-Reply-To: <20111013150642.GC6169@csn.ul.ie> (Mel Gorman's message of "Thu,
	13 Oct 2011 16:06:42 +0100")
Message-ID: <m2hb3c287e.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mel@csn.ul.ie> writes:
>
> If vm_enough_memory is being heavily hit as well, it implies that this
> workload is mmap-intensive which is pretty inefficient in itself. I

Saw it with tmpfs originally. No need to be mmap intensive. Just
do lots of IOs on tmpfs.

> guess it would also apply to workloads that are malloc-intensive for
> large buffers but I'd expect the cache line bounces to only dominate if
> there was little or no computation on the resulting buffers.

I think you severly underestimate the costs of bouncing cache lines
on >2S.

> As a result, I wonder how realistic is this test workload and who useful
> fixing this problem is in general?

It's kind of bad if tmpfs doesn't scale.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
