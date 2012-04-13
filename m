Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab2DMBoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 21:44:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40551 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2DMBoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 21:44:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F878480.60505@jp.fujitsu.com>
Date: Fri, 13 Apr 2012 10:42:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
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
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com> <20120412172309.GM1787@cmpxchg.org> <20120412174155.GC13069@google.com>
In-Reply-To: <20120412174155.GC13069@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/13 2:41), Tejun Heo wrote:

> Hello, Johannes.

> I'm still split on the issue.
> 
> * #tasks as unit of accounting / limiting is well understood (or at
>   least known).  I think this holds the same to #open files, to a
>   lesser extent.  It means there are and will continue to be people
>   wanting them.  So, they have some value in familiarity - "but... I
>   want to limit the resources consumed by tasks cuz that's what I
>   know!" factor.
> 
> * People could want counting and limiting #tasks or #open files
>   without the overhead of tracking all memory resources.  This stems
>   from the same reason #tasks was used for this sort of things in the
>   first place.  Counting tasks or open files tends to be easier and
>   cheaper than tracking all memory allocations.
> 
> So, there's spectrum of solutions between merging task counter and
> just directing everyone to kmem without distinguishing task resource
> at all, and at the moment voices in my head are succeeding at making
> cases for both directions.  What do you guys think about the above two
> issues?
> 


To be honest, I doubt that task counter is unnecessary...memcg can catch
oom situation well. I often test 'make -j' under memcg.

To the questions
*   It sounds like a 'ulimit' cgroup. How about overwriting
    ulimit values via cgroup ? (sounds joke?) Then, overhead will be small but
    I'm not sure it can be hierarchical and doesn't break userland.

    If people wants to limit the number of tasks, I think interface should provide it
    in the unit of objects. Then, I'm ok to have other subsystem for counting something.
    fork-bomb's memory overhead can be prevent by memcg. What memcg cannot handle
    is ulimit. If forkbomb exhausts all ulimit/tasks, the user cannot login.
    So, having task-limit cgroup subsys for a sandbox will make sense in some situation.

In short, I don't think it's better to have task-counting and fd-counting in memcg.
It's kmem, but it's more than that, I think.
Please provide subsys like ulimit.

Thanks,
-Kame

