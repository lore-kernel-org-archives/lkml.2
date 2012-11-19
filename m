Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2KSQDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:03:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab2KSQDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:03:19 -0500
Message-ID: <50AA582E.30602@redhat.com>
Date: Mon, 19 Nov 2012 11:02:54 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 17/19, v2] mm/migrate: Introduce migrate_misplaced_page()
References: <1353083121-4560-1-git-send-email-mingo@kernel.org> <1353083121-4560-18-git-send-email-mingo@kernel.org> <20121119022558.GA3186@gmail.com>
In-Reply-To: <20121119022558.GA3186@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 09:25 PM, Ingo Molnar wrote:
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>
>> Add migrate_misplaced_page() which deals with migrating pages from
>> faults.
>>
>> This includes adding a new MIGRATE_FAULT migration mode to
>> deal with the extra page reference required due to having to look up
>> the page.
> [...]
>
>> --- a/include/linux/migrate_mode.h
>> +++ b/include/linux/migrate_mode.h
>> @@ -6,11 +6,14 @@
>>    *	on most operations but not ->writepage as the potential stall time
>>    *	is too significant
>>    * MIGRATE_SYNC will block when migrating pages
>> + * MIGRATE_FAULT called from the fault path to migrate-on-fault for mempolicy
>> + *	this path has an extra reference count
>>    */
>
> Note, this is still the older, open-coded version.
>
> The newer replacement version created from Mel's patch which
> reuses migrate_pages() and is nicer on out-of-node-memory
> conditions and is cleaner all around can be found below.
>
> I tested it today and it appears to work fine. I noticed no
> performance improvement or performance drop from it - if it
> holds up in testing it will be part of the -v17 release of
> numa/core.

Excellent. That gets rid of the last issue with numa/base :)


-- 
All rights reversed
