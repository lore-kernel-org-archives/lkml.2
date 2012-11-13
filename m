Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2KMOti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:49:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab2KMOth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:49:37 -0500
Message-ID: <50A25DE5.1040202@redhat.com>
Date: Tue, 13 Nov 2012 09:49:09 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/19] mm: migrate: Introduce migrate_misplaced_page()
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-13-git-send-email-mgorman@suse.de> <20121113093644.GA21522@gmail.com> <20121113114344.GA26305@gmail.com>
In-Reply-To: <20121113114344.GA26305@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 06:43 AM, Ingo Molnar wrote:
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
>>
>> * Mel Gorman <mgorman@suse.de> wrote:
>>
>>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>
>>> Note: This was originally based on Peter's patch "mm/migrate: Introduce
>>> 	migrate_misplaced_page()" but borrows extremely heavily from Andrea's
>>> 	"autonuma: memory follows CPU algorithm and task/mm_autonuma stats
>>> 	collection". The end result is barely recognisable so signed-offs
>>> 	had to be dropped. If original authors are ok with it, I'll
>>> 	re-add the signed-off-bys.
>>>
>>> Add migrate_misplaced_page() which deals with migrating pages from
>>> faults.
>>>
>>> Based-on-work-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
>>> Based-on-work-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> Based-on-work-by: Andrea Arcangeli <aarcange@redhat.com>
>>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>>> ---
>>>   include/linux/migrate.h |    8 ++++
>>>   mm/migrate.c            |  104 ++++++++++++++++++++++++++++++++++++++++++++++-
>>>   2 files changed, 110 insertions(+), 2 deletions(-)
>>
>> That's a nice patch - the TASK_NUMA_FAULT approach in the
>> original patch was not very elegant.
>>
>> I've started testing it to see how well your version works.
>
> Hm, I'm seeing some instability - see the boot crash below. If I
> undo your patch it goes away.
>
> ( To help debugging this I've attached migration.patch which
>    applies your patch on top of Peter's latest queue of patches.
>    If I revert this patch then the crash goes away. )
>
> I've gone back to the well-tested page migration code from Peter
> for the time being.

Is there a place we can see your code?

Peter's patch with MIGRATE_FAULT is very much NAKed, so
this approach does need to be made to work...

You can either make the working tree public somewhere,
so we can help, or figure it out yourself. Your choice :)

-- 
All rights reversed
