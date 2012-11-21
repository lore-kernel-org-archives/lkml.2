Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2KUELi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:11:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35874 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2KUELg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:11:36 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50AC545F.5080303@jp.fujitsu.com>
Date: Wed, 21 Nov 2012 13:11:11 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg
 is disabled fix
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com> <20121120134932.055bc192.akpm@linux-foundation.org> <50AC282A.4070309@jp.fujitsu.com> <alpine.DEB.2.00.1211201847450.2278@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211201847450.2278@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/21 11:48), David Rientjes wrote:
> Move the check for !mm out of line as suggested by Andrew.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Thank you very much !

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>   include/linux/memcontrol.h |    2 +-
>   mm/memcontrol.c            |    3 +++
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -185,7 +185,7 @@ void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
>   static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
>   					     enum vm_event_item idx)
>   {
> -	if (mem_cgroup_disabled() || !mm)
> +	if (mem_cgroup_disabled())
>   		return;
>   	__mem_cgroup_count_vm_event(mm, idx);
>   }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1021,6 +1021,9 @@ void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
>   {
>   	struct mem_cgroup *memcg;
>
> +	if (!mm)
> +		return;
> +
>   	rcu_read_lock();
>   	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
>   	if (unlikely(!memcg))
>


