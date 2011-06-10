Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1FJQ6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:58:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab1FJQ6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:58:09 -0400
Message-ID: <4DF24D04.1080802@redhat.com>
Date: Fri, 10 Jun 2011 18:57:40 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Tim Deegan <Tim.Deegan@citrix.com>
Subject: Re: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node
 to world
References: <1306925044-2828-1-git-send-email-imammedo@redhat.com>	<20110601123913.GC4266@tiehlicka.suse.cz>	<4DE6399C.8070802@redhat.com>	<20110601134149.GD4266@tiehlicka.suse.cz>	<4DE64F0C.3050203@redhat.com>	<20110601152039.GG4266@tiehlicka.suse.cz>	<4DE66BEB.7040502@redhat.com>	<BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>	<4DE8D50F.1090406@redhat.com>	<BANLkTinMamg_qesEffGxKu3QkT=zyQ2MRQ@mail.gmail.com>	<4DEE26E7.2060201@redhat.com>	<20110608123527.479e6991.kamezawa.hiroyu@jp.fujitsu.com> <20110608140951.115ab1dd.akpm@linux-foundation.org>
In-Reply-To: <20110608140951.115ab1dd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 11:09 PM, Andrew Morton wrote:
> The original patch:
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4707,7 +4707,6 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
>   	if (!pn)
>   		return 1;
>
> -	mem->info.nodeinfo[node] = pn;
>   	for (zone = 0; zone<  MAX_NR_ZONES; zone++) {
>   		mz =&pn->zoneinfo[zone];
>   		for_each_lru(l)
> @@ -4716,6 +4715,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
>   		mz->on_tree = false;
>   		mz->mem = mem;
>   	}
> +	mem->info.nodeinfo[node] = pn;
>   	return 0;
>   }
>
> looks like a really good idea.  But it needs a new changelog and I'd be
> a bit reluctant to merge it as it appears that the aptch removes our
> only known way of reproducing a bug.
>
> So for now I think I'll queue the patch up unchangelogged so the issue
> doesn't get forgotten about.
>
Problem was in rhel's xen hv.
It was missing fix for imul emulation.
Details here 
http://lists.xensource.com/archives/html/xen-devel/2011-06/msg00801.html
Thanks to Tim Deegan and everyone who was involved in the discussion.

-- 
Thanks,
  Igor

