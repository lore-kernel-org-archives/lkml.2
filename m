Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab2JSSdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2JSSdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:33:32 -0400
Message-ID: <50819CED.30803@redhat.com>
Date: Fri, 19 Oct 2012 14:33:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: question on NUMA page migration
References: <5081777A.8050104@redhat.com> <1350664742.2768.40.camel@twins>  <50818A41.7030909@redhat.com> <1350669236.2768.66.camel@twins>
In-Reply-To: <1350669236.2768.66.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 01:53 PM, Peter Zijlstra wrote:
> On Fri, 2012-10-19 at 13:13 -0400, Rik van Riel wrote:

>> Another alternative might be to do the put_page inside
>> do_prot_none_numa().  That would be analogous to do_wp_page
>> disposing of the old page for the caller.
>
> It'd have to be inside migrate_misplaced_page(), can't do before
> isolate_lru_page() or the page might disappear. Doing it after is
> (obviously) too late.

Keeping an extra refcount on the page might _still_
result in it disappearing from the process by some
other means, in-between you grabbing the refcount
and invoking migration of the page.

>> I am not real happy about NUMA migration introducing its own
>> migration mode...
>
> You didn't seem to mind too much earlier, but I can remove it if you
> want.

Could have been reviewing fatigue :)

And yes, it would have been nice to not have a special
migration mode for sched/numa.

Speaking of, when do you guys plan to submit a (cleaned up)
version of the sched/numa patch series for review on lkml?

-- 
All rights reversed
