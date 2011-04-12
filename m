Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1DLKeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:34:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45461 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab1DLKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:34:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] mm, mem-hotplug: update pcp->stat_threshold when memory hotplug occur
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
In-Reply-To: <BANLkTinORojJgOdHeRMLMkKGc-Jitu-unQ@mail.gmail.com>
References: <20110412183010.B52A.A69D9226@jp.fujitsu.com> <BANLkTinORojJgOdHeRMLMkKGc-Jitu-unQ@mail.gmail.com>
Message-Id: <20110412193407.B52F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 19:34:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No good stat_threshold might makes performance hurt.
> 
> Yes. That's I want it.
> My intention is that if you write down log fully, it can help much
> newbies to understand the patch in future and it would be very clear
> Andrew to merge it.
> 
> What I want is following as.
> ==
> 
> Currently, memory hotplug doesn't updates pcp->stat_threashold.
> Then, It ends up making the wrong stat_threshold and percpu_driftmark.
> 
> It could make confusing zoneinfo or overhead by frequent draining.
> Even when memory is low and kswapd is awake, it can mismatch between
> the number of real free pages and vmstat NR_FREE_PAGES so that it can
> result in the livelock. Please look at aa4548403 for more.
> 
> This patch solves the issue.
> ==

Now, wakeup_kswapd() are using zone_watermark_ok_safe(). (ie avoid to use
per-cpu stat jiffies). Then, I don't think we have livelock chance.
Am I missing something?



