Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013Ab2DMBwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 21:52:12 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51399 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749Ab2DMBwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 21:52:09 -0400
Message-ID: <4F87865F.5060701@parallels.com>
Date: Thu, 12 Apr 2012 22:50:23 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com> <20120412172309.GM1787@cmpxchg.org> <20120412174155.GC13069@google.com> <4F878480.60505@jp.fujitsu.com>
In-Reply-To: <4F878480.60505@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.10.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 10:42 PM, KAMEZAWA Hiroyuki wrote:
> To be honest, I doubt that task counter is unnecessary...memcg can catch
> oom situation well. I often test 'make -j' under memcg.
>
> To the questions
> *   It sounds like a 'ulimit' cgroup. How about overwriting
>      ulimit values via cgroup ? (sounds joke?) Then, overhead will be small but
>      I'm not sure it can be hierarchical and doesn't break userland.
>
>      If people wants to limit the number of tasks, I think interface should provide it
>      in the unit of objects. Then, I'm ok to have other subsystem for counting something.
>      fork-bomb's memory overhead can be prevent by memcg. What memcg cannot handle
>      is ulimit. If forkbomb exhausts all ulimit/tasks, the user cannot login.
>      So, having task-limit cgroup subsys for a sandbox will make sense in some situation.
>
> In short, I don't think it's better to have task-counting and fd-counting in memcg.
> It's kmem, but it's more than that, I think.
> Please provide subsys like ulimit.
>
Kame,

You're talking about the memcg that is in the kernel today.
I think the discussion is orbiting around how it is going to be once we
start tracking kernel memory like the slab (for task_struct), or kernel 
stack pages.

In those scenarios, a fork bomb will be stopped anyway, because it will 
need kernel memory it can't grab.

