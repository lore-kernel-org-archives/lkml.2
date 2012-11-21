Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab2KUTrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:47:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab2KUTrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:47:18 -0500
Message-ID: <50AD2F86.3090303@redhat.com>
Date: Wed, 21 Nov 2012 14:46:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 36/46] mm: numa: Use a two-stage filter to restrict pages
 being migrated for unlikely task<->node relationships
References: <1353493312-8069-1-git-send-email-mgorman@suse.de> <1353493312-8069-37-git-send-email-mgorman@suse.de> <20121121182537.GB29893@gmail.com> <20121121191547.GM8218@suse.de>
In-Reply-To: <20121121191547.GM8218@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 02:15 PM, Mel Gorman wrote:
> On Wed, Nov 21, 2012 at 07:25:37PM +0100, Ingo Molnar wrote:

>> As mentioned in my other mail, this patch of yours looks very
>> similar to the numa/core commit attached below, mostly written
>> by Peter:
>>
>>    30f93abc6cb3 sched, numa, mm: Add the scanning page fault machinery

> Just to compare, this is the wording in "autonuma: memory follows CPU
> algorithm and task/mm_autonuma stats collection"
>
> +/*
> + * In this function we build a temporal CPU_node<->page relation by
> + * using a two-stage autonuma_last_nid filter to remove short/unlikely
> + * relations.

Looks like the comment came from sched/numa, but the original code
came from autonuma:

https://lkml.org/lkml/2012/8/22/629

If you want to do a real historical dig, we may still have a picture
of the whiteboard where Karen and I came up with the idea of only
migrating a page after the second touch from the same node :)

That was trying to solve the "how can we make migrate on fault as
cheap as possible?" question, and reviewing some earlier autonuma
codebase.

Not that any of this matters in the least.  AutoNUMA, sched/numa,
and balancenuma have all evolved a lot because they were able to
copy good ideas from each other, and discard overly complex or
simply bad ideas (eg. the NUMA syscalls or async page migration),
while replacing them with simpler, better ideas from the other
code bases.

Now that we (mostly) agree on what the basic infrastructure should
look like, we can figure out which placement policies work best for
various workloads.

Then we can make a choice depending on what works best, independent
of who wrote what.

-- 
All rights reversed
