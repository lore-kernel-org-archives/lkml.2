Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2DQPlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:41:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2DQPlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:41:23 -0400
Date: Tue, 17 Apr 2012 08:41:17 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120417154117.GE32402@google.com>
References: <4F862851.3040208@jp.fujitsu.com>
 <20120412113217.GB11455@somewhere.redhat.com>
 <4F86BFC6.2050400@parallels.com>
 <20120412123256.GI1787@cmpxchg.org>
 <4F86D4BD.1040305@parallels.com>
 <20120412153055.GL1787@cmpxchg.org>
 <20120412163825.GB13069@google.com>
 <20120412172309.GM1787@cmpxchg.org>
 <20120412174155.GC13069@google.com>
 <4F878480.60505@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F878480.60505@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, KAMEZAWA.

On Fri, Apr 13, 2012 at 10:42:24AM +0900, KAMEZAWA Hiroyuki wrote:
> > So, there's spectrum of solutions between merging task counter and
> > just directing everyone to kmem without distinguishing task resource
> > at all, and at the moment voices in my head are succeeding at making
> > cases for both directions.  What do you guys think about the above two
> > issues?
> 
> 
> To be honest, I doubt that task counter is unnecessary...memcg can catch
> oom situation well. I often test 'make -j' under memcg.

Heh, the double negation is confusing me.  Were you trying to say that
task_counter is necessary or was it the other way around?

> To the questions
> *   It sounds like a 'ulimit' cgroup. How about overwriting
>     ulimit values via cgroup ? (sounds joke?) Then, overhead will be small but
>     I'm not sure it can be hierarchical and doesn't break userland.
> 
>     If people wants to limit the number of tasks, I think interface should provide it
>     in the unit of objects. Then, I'm ok to have other subsystem for counting something.
>     fork-bomb's memory overhead can be prevent by memcg. What memcg cannot handle
>     is ulimit. If forkbomb exhausts all ulimit/tasks, the user cannot login.
>     So, having task-limit cgroup subsys for a sandbox will make sense in some situation.
> 
> In short, I don't think it's better to have task-counting and fd-counting in memcg.
> It's kmem, but it's more than that, I think.
> Please provide subsys like ulimit.

So, you think that while kmem would be enough to prevent fork-bombs,
it would still make sense to limit in more traditional ways
(ie. ulimit style object limits).  Hmmm....

Thanks.

-- 
tejun
