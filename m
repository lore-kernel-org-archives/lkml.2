Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423136Ab2KNSW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:22:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422887Ab2KNSW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:22:56 -0500
Message-ID: <50A3E169.4010402@redhat.com>
Date: Wed, 14 Nov 2012 13:22:33 -0500
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
Subject: Re: [PATCH 26/31] sched: numa: Make mempolicy home-node aware
References: <1352805180-1607-1-git-send-email-mgorman@suse.de> <1352805180-1607-27-git-send-email-mgorman@suse.de>
In-Reply-To: <1352805180-1607-27-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 06:12 AM, Mel Gorman wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Add another layer of fallback policy to make the home node concept
> useful from a memory allocation PoV.
>
> This changes the mpol order to:
>
>   - vma->vm_ops->get_policy	[if applicable]
>   - vma->vm_policy		[if applicable]
>   - task->mempolicy
>   - tsk_home_node() preferred	[NEW]
>   - default_policy

Why is the home node policy not the default policy?

> Note that the tsk_home_node() policy has Migrate-on-Fault enabled to
> facilitate efficient on-demand memory migration.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Turner <pjt@google.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>




-- 
All rights reversed
