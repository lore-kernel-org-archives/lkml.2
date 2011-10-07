Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab1JGWmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:42:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab1JGWmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:42:53 -0400
Message-ID: <4E8F8062.2080105@redhat.com>
Date: Fri, 07 Oct 2011 18:42:42 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        Josh Boyer <jwboyer@redhat.com>, aarcange@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Abort reclaim/compaction if compaction can proceed
References: <1318000643-27996-1-git-send-email-mgorman@suse.de> <1318000643-27996-3-git-send-email-mgorman@suse.de> <4E8F5BEA.3040502@redhat.com> <20111007202417.GD6418@suse.de>
In-Reply-To: <20111007202417.GD6418@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2011 04:24 PM, Mel Gorman wrote:
> On Fri, Oct 07, 2011 at 04:07:06PM -0400, Rik van Riel wrote:
>> On 10/07/2011 11:17 AM, Mel Gorman wrote:
>>> If compaction can proceed, shrink_zones() stops doing any work but
>>> the callers still shrink_slab(), raises the priority and potentially
>>> sleeps.  This patch aborts direct reclaim/compaction entirely if
>>> compaction can proceed.
>>>
>>> Signed-off-by: Mel Gorman<mgorman@suse.de>
>>
>> This patch makes sense to me, but I have not tested it like
>> the first one.
>>
>
> Do if you can.

I'll probably build a kernel with your patch in it on
Sunday - I'll be walking across a mountain tomorrow :)

> It's marginal and could be confirmation bias on my part. Basically,
> there is noise when this path is being exercised but there were fewer
> slabs scanned.  However, I don't know what the variances are and
> whether the reduction was within the noise or not but it makes sense
> that it would scan less.  If I profiled carefully, I might be able
> to show that a few additional cycles are spent raising the priority
> but it would be marginal.

This seems clear enough.

> While patch 1 is very clear, patch 2 depends on reviewers deciding it
> "makes sense".
>
>> Having said that, I'm pretty sure the patch is ok :)
>>
>
> Care to ack?

Sure.

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
