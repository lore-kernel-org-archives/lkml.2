Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2FSASc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:18:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59348 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2FSASa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:18:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDFC4D4.1030303@jp.fujitsu.com>
Date: Tue, 19 Jun 2012 09:16:20 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        cgroups@vger.kernel.org, devel@openvz.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 23/25] memcg: propagate kmem limiting information to
 children
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-24-git-send-email-glommer@parallels.com> <4FDF20ED.4090401@jp.fujitsu.com> <4FDF227B.3080601@parallels.com>
In-Reply-To: <4FDF227B.3080601@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/18 21:43), Glauber Costa wrote:
> On 06/18/2012 04:37 PM, Kamezawa Hiroyuki wrote:
>> (2012/06/18 19:28), Glauber Costa wrote:
>>> The current memcg slab cache management fails to present satisfatory hierarchical
>>> behavior in the following scenario:
>>>
>>> ->   /cgroups/memory/A/B/C
>>>
>>> * kmem limit set at A
>>> * A and B empty taskwise
>>> * bash in C does find /
>>>
>>> Because kmem_accounted is a boolean that was not set for C, no accounting
>>> would be done. This is, however, not what we expect.
>>>
>>
>> Hmm....do we need this new routines even while we have mem_cgroup_iter() ?
>>
>> Doesn't this work ?
>>
>> 	struct mem_cgroup {
>> 		.....
>> 		bool kmem_accounted_this;
>> 		atomic_t kmem_accounted;
>> 		....
>> 	}
>>
>> at set limit
>>
>> 	....set_limit(memcg) {
>>
>> 		if (newly accounted) {
>> 			mem_cgroup_iter() {
>> 				atomic_inc(&iter->kmem_accounted)
>> 			}
>> 		} else {
>> 			mem_cgroup_iter() {
>> 				atomic_dec(&iter->kmem_accounted);
>> 			}
>> 	}
>>
>>
>> hm ? Then, you can see kmem is accounted or not by atomic_read(&memcg->kmem_accounted);
>>
> 
> Accounted by itself / parent is still useful, and I see no reason to use
> an atomic + bool if we can use a pair of bits.
> 
> As for the routine, I guess mem_cgroup_iter will work... It does a lot
> more than I need, but for the sake of using what's already in there, I
> can switch to it with no problems.
> 

Hmm. please start from reusing existing routines.
If it's not enough, some enhancement for generic cgroup  will be welcomed
rather than completely new one only for memcg.

Thanks,
-Kame



