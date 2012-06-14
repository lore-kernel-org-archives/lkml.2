Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2FNI6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:58:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:13574 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2FNI6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:58:14 -0400
Message-ID: <4FD9A6B6.50503@huawei.com>
Date: Thu, 14 Jun 2012 16:54:14 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>, <dhillf@gmail.com>,
        <rientjes@google.com>, <mhocko@suse.cz>, <akpm@linux-foundation.org>,
        <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH -V9 09/15] mm/hugetlb: Add new HugeTLB cgroup
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1339583254-895-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.162]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline

> +struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
> +{
> +	if (s)


Neither cgroup_subsys_state() or task_subsys_state() will ever return NULL,
so here 's' won't be NULL.

> +		return container_of(s, struct hugetlb_cgroup, css);
> +	return NULL;
> +}
> +
> +static inline
> +struct hugetlb_cgroup *hugetlb_cgroup_from_cgroup(struct cgroup *cgroup)
> +{
> +	return hugetlb_cgroup_from_css(cgroup_subsys_state(cgroup,
> +							   hugetlb_subsys_id));
> +}
> +
> +static inline
> +struct hugetlb_cgroup *hugetlb_cgroup_from_task(struct task_struct *task)
> +{
> +	return hugetlb_cgroup_from_css(task_subsys_state(task,
> +							 hugetlb_subsys_id));
> +}

