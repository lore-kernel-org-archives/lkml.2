Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab2AJQ6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:58:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57402 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2AJQ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:58:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120110164407.GD4118@suse.de>
References: <CAJd=RBAqzawZ=jEFt7TrZgU0gaejMkfiBxzH7Y19qqNnsZrJGw@mail.gmail.com>
	<20120110094452.GC4118@suse.de>
	<CAJd=RBA7vj83SFQFMS5WaRCfz2ndGJXepBqi5tK0LPjnBYYgfg@mail.gmail.com>
	<20120110164407.GD4118@suse.de>
Date: Wed, 11 Jan 2012 00:58:50 +0800
Message-ID: <CAJd=RBCGN6LGqTH7ubQ5FuW-wYyLB5ao+58ffhipNni1Tt_JUg@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: fix setting reclaim mode
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:44 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Tue, Jan 10, 2012 at 11:58:03PM +0800, Hillf Danton wrote:
>> From: Hillf Danton <dhillf@gmail.com>
>> [PATCH] mm: vmscan: fix setting reclaim mode
>>
>> The comment says, initially assume we are entering either lumpy reclaim or
>> reclaim/compaction, and depending on the reclaim order, we will either set the
>> sync mode or just reclaim order-0 pages later.
>>
>> On other hand, order-0 reclaim, instead of sync reclaim, is expected when
>> under memory pressure, but the check for memory pressure is incorrect,
>> leading to sync reclaim at low reclaim priorities.
>>
>> And the result is sync reclaim is set for high priorities.
>>
>
> RECLAIM_MODE_SYNC is only set for RECLAIM_MODE_LUMPYRECLAIM. Even when
> using RECLAIM_MODE_LUMPYRECLAIM, it should only be set when reclaim
> is under memory pressure and failing to reclaim the necessry pages
> (priority < DEF_PRIORITY - 2). Once in symc reclaim, reclaim will call
> wait_on_page_writeback() on dirty pages which potentially leads to
> significant stalls (one of the reasons why RECLAIM_MODE_LUMPYRECLAIM
> sucks and why compaction is preferred). Your patch means sync reclaim
> is used even when priority == DEF_PRIORITY. This is unexpected.
>
> Your changelog really needs to explain what the problem is that you
> have encountered and why this patch fixes it. It's not like some of
> your other patches which were minor performance optimisations that
> were self-evident.
>
Hi Mel

To avoid another step in wrong direction, I'd goto bed now,
it is about 1:09 AM.
When sane again, I will try to understand your comment.

Best
Hillf
