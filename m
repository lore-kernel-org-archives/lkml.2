Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab1DLKMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:12:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34677 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab1DLKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:12:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B2ueWRoJeMpiZjghXu/YxyHpNgiamnQCwyAMHmQez9XbGMqxfAD+itsTP4TfLVpkEV
         z29tSBInaBNq4v+J/L+P4+qWWM96oZJiu3upcOu0T669xPoI+heUBmesd6bBUX3BiLlZ
         bkfbbn/3/8mD7HiA5hN+eJ3IeWIvtvDbispbU=
MIME-Version: 1.0
In-Reply-To: <20110412183010.B52A.A69D9226@jp.fujitsu.com>
References: <20110411170134.035E.A69D9226@jp.fujitsu.com>
	<BANLkTi=fEejkrPdX27bFi1x+dHpOSGxQaQ@mail.gmail.com>
	<20110412183010.B52A.A69D9226@jp.fujitsu.com>
Date: Tue, 12 Apr 2011 19:12:02 +0900
Message-ID: <BANLkTinORojJgOdHeRMLMkKGc-Jitu-unQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm, mem-hotplug: update pcp->stat_threshold when
 memory hotplug occur
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 6:29 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>> Hi, KOSAKI
>>
>> On Mon, Apr 11, 2011 at 5:01 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Currently, cpu hotplug updates pcp->stat_threashold, but memory
>> > hotplug doesn't. there is no reason.
>> >
>> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > Acked-by: Mel Gorman <mel@csn.ul.ie>
>> > Acked-by: Christoph Lameter <cl@linux.com>
>>
>> I can think it makes sense so I don't oppose the patch merging.
>> But as you know I am very keen on the description.
>>
>> What is the problem if hotplug doesn't do it?
>> I means the patch solves what's problem?
>>
>> Please write down fully for better description.
>> Thanks.
>
> No real world issue. I found the fault by code review.

I don't mean we should solve only real world issue.
Just finding out code review is much valuable. :)

> No good stat_threshold might makes performance hurt.

Yes. That's I want it.
My intention is that if you write down log fully, it can help much
newbies to understand the patch in future and it would be very clear
Andrew to merge it.

What I want is following as.

==

Currently, memory hotplug doesn't updates pcp->stat_threashold.
Then, It ends up making the wrong stat_threshold and percpu_driftmark.

It could make confusing zoneinfo or overhead by frequent draining.
Even when memory is low and kswapd is awake, it can mismatch between
the number of real free pages and vmstat NR_FREE_PAGES so that it can
result in the livelock. Please look at aa4548403 for more.

This patch solves the issue.
==


-- 
Kind regards,
Minchan Kim
