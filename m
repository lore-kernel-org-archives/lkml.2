Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551Ab2DMCu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 22:50:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59358 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934178Ab2DMCuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 22:50:25 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F8793FC.5030209@jp.fujitsu.com>
Date: Fri, 13 Apr 2012 11:48:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com> <20120412172309.GM1787@cmpxchg.org> <20120412174155.GC13069@google.com> <4F878480.60505@jp.fujitsu.com> <4F87865F.5060701@parallels.com>
In-Reply-To: <4F87865F.5060701@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/13 10:50), Glauber Costa wrote:

> On 04/12/2012 10:42 PM, KAMEZAWA Hiroyuki wrote:
>> To be honest, I doubt that task counter is unnecessary...memcg can catch
>> oom situation well. I often test 'make -j' under memcg.
>>
>> To the questions
>> *   It sounds like a 'ulimit' cgroup. How about overwriting
>>      ulimit values via cgroup ? (sounds joke?) Then, overhead will be small but
>>      I'm not sure it can be hierarchical and doesn't break userland.
>>
>>      If people wants to limit the number of tasks, I think interface should provide it
>>      in the unit of objects. Then, I'm ok to have other subsystem for counting something.
>>      fork-bomb's memory overhead can be prevent by memcg. What memcg cannot handle
>>      is ulimit. If forkbomb exhausts all ulimit/tasks, the user cannot login.
>>      So, having task-limit cgroup subsys for a sandbox will make sense in some situation.
>>
>> In short, I don't think it's better to have task-counting and fd-counting in memcg.
>> It's kmem, but it's more than that, I think.
>> Please provide subsys like ulimit.
>>
> Kame,
> 
> You're talking about the memcg that is in the kernel today.
> I think the discussion is orbiting around how it is going to be once we
> start tracking kernel memory like the slab (for task_struct), or kernel 
> stack pages.
> 
> In those scenarios, a fork bomb will be stopped anyway, because it will 
> need kernel memory it can't grab.
> 



fork-bomb can be caught by some method.


I just consider about 'task' cgroup. You can know the number of tasks by reading
tasks file even if we don't have task cgroup. Because of this, using
task cgroup for accounting the number of tasks doesn't make sense to me.
But, here, Tejun? mentioned accounting the number of 'fd'. 

Hearing that, I think of ulimit.

We do resource accounting based on cgroup. But there are another limiting
feature as ulimit, sysctl, etc...This makes total view of resource accounting in Linux
complicated. So, I wonder whether cgroup can be a unified control feature and have
subsys for ulimit or ipc, by overriding other control stuffs.

But  resources which doesn't belong to 'thread' ...as memory may add something
messy to cgroup, it's accounting resources based on threads.

Thanks,
-Kame




