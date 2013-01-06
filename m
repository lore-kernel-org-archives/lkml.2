Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3AFIaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 03:30:00 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:18428 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3AFI34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 03:29:56 -0500
Message-ID: <50E935D5.4040402@huawei.com>
Date: Sun, 6 Jan 2013 16:29:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <paul@paulmenage.org>, <glommer@parallels.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <peterz@infradead.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/13] cpuset: make CPU / memory hotplug propagation asynchronous
References: <1357248967-24959-1-git-send-email-tj@kernel.org> <1357248967-24959-11-git-send-email-tj@kernel.org>
In-Reply-To: <1357248967-24959-11-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void schedule_cpuset_propagate_hotplug(struct cpuset *cs)
> +{
> +	/*
> +	 * Pin @cs.  The refcnt will be released when the work item
> +	 * finishes executing.
> +	 */
> +	if (!css_tryget(&cs->css))
> +		return;
> +
> +	/*
> +	 * Queue @cs->empty_cpuset_work.  If already pending, lose the css

cs->hotplug_work

> +	 * ref.  cpuset_propagate_hotplug_wq is ordered and propagation
> +	 * will happen in the order this function is called.
> +	 */
> +	if (!queue_work(cpuset_propagate_hotplug_wq, &cs->hotplug_work))
> +		css_put(&cs->css);
>  }

