Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2D3Ivc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:51:32 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42050 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2D3Iva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:51:30 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "cgroups\@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: Re: [RFC][PATCH 2/7 v2] memcg: fix error code in hugetlb_force_memcg_empty()
In-Reply-To: <4F9A33CB.8040304@jp.fujitsu.com>
References: <4F9A327A.6050409@jp.fujitsu.com> <4F9A33CB.8040304@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 30 Apr 2012 14:19:46 +0530
Message-ID: <87y5pd8uz9.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12043008-2000-0000-0000-0000074AF8BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> EBUSY should be returned.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/hugetlb.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 17ae2e4..4dd6b39 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1922,8 +1922,11 @@ int hugetlb_force_memcg_empty(struct cgroup *cgroup)
>  	int ret = 0, idx = 0;
>
>  	do {
> -		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
> +		if (cgroup_task_count(cgroup)
> +			|| !list_empty(&cgroup->children)) {
> +			ret = -EBUSY;
>  			goto out;
> +		}
>  		/*
>  		 * If the task doing the cgroup_rmdir got a signal
>  		 * we don't really need to loop till the hugetlb resource

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh

