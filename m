Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2KPOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:09:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab2KPOJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:09:56 -0500
Message-ID: <50A64921.5020702@redhat.com>
Date: Fri, 16 Nov 2012 09:09:37 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/43] mm: numa: Support NUMA hinting page faults from
 gup/gup_fast
References: <1353064973-26082-1-git-send-email-mgorman@suse.de> <1353064973-26082-8-git-send-email-mgorman@suse.de>
In-Reply-To: <1353064973-26082-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 06:22 AM, Mel Gorman wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> Introduce FOLL_NUMA to tell follow_page to check
> pte/pmd_numa. get_user_pages must use FOLL_NUMA, and it's safe to do
> so because it always invokes handle_mm_fault and retries the
> follow_page later.
>
> KVM secondary MMU page faults will trigger the NUMA hinting page
> faults through gup_fast -> get_user_pages -> follow_page ->
> handle_mm_fault.
>
> Other follow_page callers like KSM should not use FOLL_NUMA, or they
> would fail to get the pages if they use follow_page instead of
> get_user_pages.
>
> [ This patch was picked up from the AutoNUMA tree. ]
>
> Originally-by: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Rik van Riel <riel@redhat.com>
> [ ported to this tree. ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
