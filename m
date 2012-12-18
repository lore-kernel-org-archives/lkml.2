Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2LRSjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:39:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab2LRSjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:39:40 -0500
Message-ID: <50D0AF65.90701@redhat.com>
Date: Tue, 18 Dec 2012 13:01:09 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] mm: cond_resched in tlb_flush_mmu to fix soft lockups
 on !CONFIG_PREEMPT
References: <1355847088-1207-1-git-send-email-mhocko@suse.cz>
In-Reply-To: <1355847088-1207-1-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 11:11 AM, Michal Hocko wrote:
> Since e303297 (mm: extended batches for generic mmu_gather) we are batching
> pages to be freed until either tlb_next_batch cannot allocate a new batch or we
> are done.
>
> This works just fine most of the time but we can get in troubles with
> non-preemptible kernel (CONFIG_PREEMPT_NONE or CONFIG_PREEMPT_VOLUNTARY) on
> large machines where too aggressive batching might lead to soft lockups during
> process exit path (exit_mmap) because there are no scheduling points down the
> free_pages_and_swap_cache path and so the freeing can take long enough to
> trigger the soft lockup.
>
> The lockup is harmless except when the system is setup to panic on
> softlockup which is not that unusual.
>
> The simplest way to work around this issue is to explicitly cond_resched per
> batch in tlb_flush_mmu (1020 pages on x86_64).

> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Cc: stable@vger.kernel.org # 3.0 and higher

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
