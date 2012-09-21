Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2IUQeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:34:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64135 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2IUQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:34:09 -0400
Date: Fri, 21 Sep 2012 09:34:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120921163404.GC7264@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-5-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347977050-29476-5-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 06:04:01PM +0400, Glauber Costa wrote:
>  #ifdef CONFIG_MEMCG_KMEM
> +static struct cftype kmem_cgroup_files[] = {
> +	{
> +		.name = "kmem.limit_in_bytes",
> +		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
> +		.write_string = mem_cgroup_write,
> +		.read = mem_cgroup_read,
> +	},
> +	{
> +		.name = "kmem.usage_in_bytes",
> +		.private = MEMFILE_PRIVATE(_KMEM, RES_USAGE),
> +		.read = mem_cgroup_read,
> +	},
> +	{
> +		.name = "kmem.failcnt",
> +		.private = MEMFILE_PRIVATE(_KMEM, RES_FAILCNT),
> +		.trigger = mem_cgroup_reset,
> +		.read = mem_cgroup_read,
> +	},
> +	{
> +		.name = "kmem.max_usage_in_bytes",
> +		.private = MEMFILE_PRIVATE(_KMEM, RES_MAX_USAGE),
> +		.trigger = mem_cgroup_reset,
> +		.read = mem_cgroup_read,
> +	},
> +	{},
> +};
> +
>  static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
>  {
>  	return mem_cgroup_sockets_init(memcg, ss);
> @@ -4961,6 +5015,12 @@ mem_cgroup_create(struct cgroup *cont)
>  		int cpu;
>  		enable_swap_cgroup();
>  		parent = NULL;
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +		WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
> +					   kmem_cgroup_files));
> +#endif
> +

Why not just make it part of mem_cgroup_files[]?

Thanks.

-- 
tejun
