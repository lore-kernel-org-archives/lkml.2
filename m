Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab1CIGRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:17:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42771 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1CIGRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:17:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: avagin@gmail.com
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
Cc: kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D767D43.5020802@gmail.com>
References: <20110308120615.7EB9.A69D9226@jp.fujitsu.com> <4D767D43.5020802@gmail.com>
Message-Id: <20110309145457.0400.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Mar 2011 15:17:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Hi, 

Hmmm...
If I could observed your patch, I did support your opinion. but I didn't. so, now I'm 
curious why we got the different conclusion. tommorow, I'll try to construct a test 
environment to reproduce your system.

Unfortunatelly, zone->all_unreclamable is unreliable value while hibernation processing.
Then I doubt current your patch is enough acceptable. but I'm not against to make alternative
if we can observe the same phenomenon.

At minimum, I also dislike kernel hang up issue.

Thanks.

