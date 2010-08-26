Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab0HZAwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:52:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0HZAwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:52:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=D/rY3kv/gYn9sevGEr8BTXQl8TRyXBYcxnKNadbK1w61MLdzXPLtiVGBW8CTZoUwO
	ofptzbrWJf8HmwuD5uKRw==
Date: Wed, 25 Aug 2010 17:52:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/2][BUGFIX] oom: remove totalpage normalization from
 oom_badness()
In-Reply-To: <20100826093923.d4ac29b6.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1008251746200.28401@chino.kir.corp.google.com>
References: <20100825184001.F3EF.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1008250300500.13300@chino.kir.corp.google.com> <20100826093923.d4ac29b6.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, KAMEZAWA Hiroyuki wrote:

> I'm now trying to write a userspace tool to calculate this, for me.
> Then, could you update documentation ? 
> ==
> 3.2 /proc/<pid>/oom_score - Display current oom-killer score
> -------------------------------------------------------------
> 
> This file can be used to check the current score used by the oom-killer is for
> any given <pid>. Use it together with /proc/<pid>/oom_adj to tune which
> process should be killed in an out-of-memory situation.
> ==
> 

You'll want to look at section 3.1 of Documentation/filesystems/proc.txt, 
which describes /proc/pid/oom_score_adj, not 3.2.

> add a some documentation like:
> ==
> (For system monitoring tool developpers, not for usual users.)
> oom_score calculation is implemnentation dependent and can be modified without
> any caution. But current logic is
> 
> oom_score = ((proc's rss + proc's swap) / (available ram + swap)) + oom_score_adj
> 

I'd hesitate to state the formula outside of the implementation and 
instead focus on the semantics of oom_score_adj (as a proportion of 
available memory compared to other tasks), which I tried doing in section 
3.1.  Then, the userspace tool only need be concerned about the units of 
oom_score_adj rather than whether rss, swap, or later extentions such as 
shm are added.

Thanks for working on this, Kame!
