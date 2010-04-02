Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0DBPPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:15:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab0DBPPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:15:07 -0400
Date: Fri, 2 Apr 2010 17:14:04 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/7] mm: preemptibility
Message-ID: <20100402151404.GK5825@random.random>
References: <20100402141601.435955404@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402141601.435955404@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 04:16:01PM +0200, Peter Zijlstra wrote:
> Hi,
> 
> This (incomplete) patch-set makes part of the mm a lot more preemptible.
> It converts i_mmap_lock and anon_vma->lock to mutexes.
> On the way there it also makes mmu_gather preemptible.
> 
> The main motivation was making mm_take_all_locks() preemptible, since
> it appears people are nesting hundreds of spinlocks there.
> 
> The side-effects are that we can finally make mmu_gather preemptible,
> something which lots of people have wanted to do for a long time.
> 
> It also gets us anon_vma refcounting which seems to be wanted by
> KSM as well as Mel's compaction work.
> 
> This patch set seems to build and boot on my x86_64 machine and even
> builds a kernel. I'll work on getting PPC working again and audit other
> architectures their mmu_gather implementation.

This is also the needed bit to allow to schedule in the mmu notifier
methods by switching from rcu to srcu there. That will make XPMEM
happy by allowing all mmu notifier methods to schedule. Considering
this may not slowdown the more important fast paths, it seems overall
beneficial effort to me.

Thanks,
Andrea
