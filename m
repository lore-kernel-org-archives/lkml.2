Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2KPOJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:09:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab2KPOJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:09:32 -0500
Message-ID: <50A648FF.2040707@redhat.com>
Date: Fri, 16 Nov 2012 09:09:03 -0500
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
Subject: Re: [PATCH 06/43] mm: numa: Make pte_numa() and pmd_numa() a generic
 implementation
References: <1353064973-26082-1-git-send-email-mgorman@suse.de> <1353064973-26082-7-git-send-email-mgorman@suse.de>
In-Reply-To: <1353064973-26082-7-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 06:22 AM, Mel Gorman wrote:
> It was pointed out by Ingo Molnar that the per-architecture definition of
> the NUMA PTE helper functions means that each supporting architecture
> will have to cut and paste it which is unfortunate. He suggested instead
> that the helpers should be weak functions that can be overridden by the
> architecture.
>
> This patch moves the helpers to mm/pgtable-generic.c and makes them weak
> functions. Architectures wishing to use this will still be required to
> define _PAGE_NUMA and potentially update their p[te|md]_present and
> pmd_bad helpers if they choose to make PAGE_NUMA similar to PROT_NONE.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Is uninlining these simple tests really the right thing to do,
or would they be better off as inlines in asm-generic/pgtable.h ?

-- 
All rights reversed
