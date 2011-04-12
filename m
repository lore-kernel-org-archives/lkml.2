Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1DLKmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:42:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63488 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab1DLKmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=I/XfAo8A+NaZP+L7yMKg0RXmVdfcjzQoe83t2ZnvF55N/JadV4UBNWLHf2L1mmWQJG
         rXSOf8VDFLoNh10Uy0nYnqcwxzhmkMahDvaClz4DbN6YmRZ1BBoalEMS7Eq2RggHm4uV
         gs8S/CBPLk91MOG7HkhGhp+JBoW57z+lm3NzQ=
MIME-Version: 1.0
In-Reply-To: <20110412193407.B52F.A69D9226@jp.fujitsu.com>
References: <20110412183010.B52A.A69D9226@jp.fujitsu.com>
	<BANLkTinORojJgOdHeRMLMkKGc-Jitu-unQ@mail.gmail.com>
	<20110412193407.B52F.A69D9226@jp.fujitsu.com>
Date: Tue, 12 Apr 2011 19:42:07 +0900
Message-ID: <BANLkTi=4jV8f23n3rp7Oo8rY_ZVPG1pMbQ@mail.gmail.com>
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

On Tue, Apr 12, 2011 at 7:34 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > No good stat_threshold might makes performance hurt.
>>
>> Yes. That's I want it.
>> My intention is that if you write down log fully, it can help much
>> newbies to understand the patch in future and it would be very clear
>> Andrew to merge it.
>>
>> What I want is following as.
>> ==
>>
>> Currently, memory hotplug doesn't updates pcp->stat_threashold.
>> Then, It ends up making the wrong stat_threshold and percpu_driftmark.
>>
>> It could make confusing zoneinfo or overhead by frequent draining.
>> Even when memory is low and kswapd is awake, it can mismatch between
>> the number of real free pages and vmstat NR_FREE_PAGES so that it can
>> result in the livelock. Please look at aa4548403 for more.
>>
>> This patch solves the issue.
>> ==
>
> Now, wakeup_kswapd() are using zone_watermark_ok_safe(). (ie avoid to use
> per-cpu stat jiffies). Then, I don't think we have livelock chance.
> Am I missing something?
>

I have no idea. I just referenced the description in aa4548403.
As I look code, zone_watermark_ok_safe works well if percpu_drift_mark
is set rightly. but if memory hotplug happens, zone->present_pages
would be changed so that it can affect wmarks. It means it can affect
percpu_drift_mark, I think.

My point is to write down the description clear.

-- 
Kind regards,
Minchan Kim
