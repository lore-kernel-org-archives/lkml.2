Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0HZBIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:08:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41505 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0HZBIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:08:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 26 Aug 2010 10:03:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/2][BUGFIX] oom: remove totalpage normalization from
 oom_badness()
Message-Id: <20100826100355.05fcfd87.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1008251746200.28401@chino.kir.corp.google.com>
References: <20100825184001.F3EF.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1008250300500.13300@chino.kir.corp.google.com>
	<20100826093923.d4ac29b6.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1008251746200.28401@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 17:52:06 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 26 Aug 2010, KAMEZAWA Hiroyuki wrote:
> 
> > I'm now trying to write a userspace tool to calculate this, for me.
> > Then, could you update documentation ? 
> > ==
> > 3.2 /proc/<pid>/oom_score - Display current oom-killer score
> > -------------------------------------------------------------
> > 
> > This file can be used to check the current score used by the oom-killer is for
> > any given <pid>. Use it together with /proc/<pid>/oom_adj to tune which
> > process should be killed in an out-of-memory situation.
> > ==
> > 
> 
> You'll want to look at section 3.1 of Documentation/filesystems/proc.txt, 
> which describes /proc/pid/oom_score_adj, not 3.2.
> 
> > add a some documentation like:
> > ==
> > (For system monitoring tool developpers, not for usual users.)
> > oom_score calculation is implemnentation dependent and can be modified without
> > any caution. But current logic is
> > 
> > oom_score = ((proc's rss + proc's swap) / (available ram + swap)) + oom_score_adj
> > 
> 
> I'd hesitate to state the formula outside of the implementation and 
> instead focus on the semantics of oom_score_adj (as a proportion of 
> available memory compared to other tasks), which I tried doing in section 
> 3.1.  Then, the userspace tool only need be concerned about the units of 
> oom_score_adj rather than whether rss, swap, or later extentions such as 
> shm are added.
> 
> Thanks for working on this, Kame!
> 
BTW, why you don't subtract the amount of Hugepages ?

The old code did
	"totalrampages - hugepage" as available memory.

IIUC, the number of hugepages is not accounted into mm->rss, so, isn't it
better to subtract # of hugepage ?
Hmm...makes no difference ?

Thanks,
-Kame






