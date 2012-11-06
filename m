Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2KFTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:16:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2KFTQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:16:57 -0500
Message-ID: <509962B6.1030204@redhat.com>
Date: Tue, 06 Nov 2012 14:19:18 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/19] mm: mempolicy: Add MPOL_MF_LAZY
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-15-git-send-email-mgorman@suse.de>
In-Reply-To: <1352193295-26815-15-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 04:14 AM, Mel Gorman wrote:
> From: Lee Schermerhorn <lee.schermerhorn@hp.com>
>
> NOTE: Once again there is a lot of patch stealing and the end result
> 	is sufficiently different that I had to drop the signed-offs.
> 	Will re-add if the original authors are ok with that.
>
> This patch adds another mbind() flag to request "lazy migration".  The
> flag, MPOL_MF_LAZY, modifies MPOL_MF_MOVE* such that the selected
> pages are marked PROT_NONE. The pages will be migrated in the fault
> path on "first touch", if the policy dictates at that time.
>
> "Lazy Migration" will allow testing of migrate-on-fault via mbind().
> Also allows applications to specify that only subsequently touched
> pages be migrated to obey new policy, instead of all pages in range.
> This can be useful for multi-threaded applications working on a
> large shared data area that is initialized by an initial thread
> resulting in all pages on one [or a few, if overflowed] nodes.
> After PROT_NONE, the pages in regions assigned to the worker threads
> will be automatically migrated local to the threads on 1st touch.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

