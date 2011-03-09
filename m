Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab1CIF7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 00:59:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39219 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1CIF7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 00:59:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Mar 2011 14:52:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: avagin@gmail.com
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable()
Message-Id: <20110309145239.ba31b415.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4D767D43.5020802@gmail.com>
References: <20110307135831.9e0d7eaa.akpm@linux-foundation.org>
	<20110308094438.1ba05ed2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110308120615.7EB9.A69D9226@jp.fujitsu.com>
	<4D767D43.5020802@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Mar 2011 22:02:27 +0300
"avagin@gmail.com" <avagin@gmail.com> wrote:

> On 03/08/2011 06:06 AM, KOSAKI Motohiro wrote:
> >>>> Hmm.. Although it solves the problem, I think it's not a good idea that
> >>>> depends on false alram and give up the retry.
> >>>
> >>> Any alternative proposals?  We should get the livelock fixed if possible..
> >>
> >> I agree with Minchan and can't think this is a real fix....
> >> Andrey, I'm now trying your fix and it seems your fix for oom-killer,
> >> 'skip-zombie-process' works enough good for my environ.
> >>
> >> What is your enviroment ? number of cpus ? architecture ? size of memory ?
> >
> > me too. 'skip-zombie-process V1' work fine. and I didn't seen this patch
> > improve oom situation.
> >
> > And, The test program is purely fork bomb. Our oom-killer is not silver
> > bullet for fork bomb from very long time ago. That said, oom-killer send
> > SIGKILL and start to kill the victim process. But, it doesn't prevent
> > to be created new memory hogging tasks. Therefore we have no gurantee
> > to win process exiting and creating race.
> 
> I think a live-lock is a bug, even if it's provoked by fork bomds.
> 

I tried to write fork-bomb-detector in oom-kill layer but I think
it should be co-operative with do_fork(), now.
IOW, some fork() should return -ENOMEM under OOM condition.

I'd like to try some but if you have some idea, please do.


> And now I want say some words about zone->all_unreclaimable. I think 
> this flag is "conservative". It is set when situation is bad and it's 
> unset when situation get better. If we have a small number of 
> reclaimable  pages, the situation is still bad. What do you mean, when 
> say that kernel is alive? If we have one reclaimable page, is the kernel 
> alive? Yes, it can work, it will generate many page faults and do 
> something, but anyone say that it is more dead than alive.
> 
> Try to look at it from my point of view. The patch will be correct and 
> the kernel will be more alive.
> 
> Excuse me, If I'm mistaken...
> 

Mayne something more casual interface than oom-kill should be provided.
I wonder I can add memory-reclaim-priority to memory cgroup and
allow control of page fault latency for applicaton...
Maybe "soft_limit" for memcg, it's implemented now, works to some extent.

Thanks,
-Kame

