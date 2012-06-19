Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2FSANq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:13:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45084 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2FSANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:13:45 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDFC3A8.7010301@jp.fujitsu.com>
Date: Tue, 19 Jun 2012 09:11:20 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        cgroups@vger.kernel.org, devel@openvz.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v4 05/25] memcg: Always free struct memcg through schedule_work()
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-6-git-send-email-glommer@parallels.com> <4FDF1A0D.6080204@jp.fujitsu.com> <4FDF1AAE.4080209@parallels.com>
In-Reply-To: <4FDF1AAE.4080209@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/18 21:10), Glauber Costa wrote:
> On 06/18/2012 04:07 PM, Kamezawa Hiroyuki wrote:
>> (2012/06/18 19:27), Glauber Costa wrote:
>>> Right now we free struct memcg with kfree right after a
>>> rcu grace period, but defer it if we need to use vfree() to get
>>> rid of that memory area. We do that by need, because we need vfree
>>> to be called in a process context.
>>>
>>> This patch unifies this behavior, by ensuring that even kfree will
>>> happen in a separate thread. The goal is to have a stable place to
>>> call the upcoming jump label destruction function outside the realm
>>> of the complicated and quite far-reaching cgroup lock (that can't be
>>> held when calling neither the cpu_hotplug.lock nor the jump_label_mutex)
>>>
>>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>>> CC: Tejun Heo<tj@kernel.org>
>>> CC: Li Zefan<lizefan@huawei.com>
>>> CC: Kamezawa Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>>> CC: Johannes Weiner<hannes@cmpxchg.org>
>>> CC: Michal Hocko<mhocko@suse.cz>
>>
>> How about cut out this patch and merge first as simple cleanu up and
>> to reduce patch stack on your side ?
>>
>> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> 
> I believe this is already in the -mm tree (from the sock memcg fixes)
> 
> But actually, my main trouble with this series here, is that I am basing
> it on Pekka's tree, while some of the fixes are in -mm already.
> If I'd base it on -mm I would lose some of the stuff as well.
> 
> Maybe Pekka can merge the current -mm with his tree?
> 
> So far I am happy with getting comments from people about the code, so I
> did not get overly concerned about that.
> 

Sure. thank you.
-Kame


