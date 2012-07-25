Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2GYTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:25:58 -0400
Received: from shutemov.name ([176.9.204.213]:44288 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2GYTZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:25:56 -0400
Date: Wed, 25 Jul 2012 22:26:50 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        cgroups@vger.kernel.org, Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 01/10] slab/slub: struct memcg_params
Message-ID: <20120725192650.GA5163@shutemov.name>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com>
 <1343227101-14217-2-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343227101-14217-2-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 06:38:12PM +0400, Glauber Costa wrote:
> For the kmem slab controller, we need to record some extra
> information in the kmem_cache structure.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/slab.h     |    7 +++++++
>  include/linux/slab_def.h |    4 ++++
>  include/linux/slub_def.h |    3 +++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 0dd2dfa..3152bcd 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -177,6 +177,13 @@ unsigned int kmem_cache_size(struct kmem_cache *);
>  #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>  #endif
>  
> +#ifdef CONFIG_MEMCG_KMEM
> +struct mem_cgroup_cache_params {
> +	struct mem_cgroup *memcg;
> +	int id;
> +};

IIUC, we only need the id to make slab name unique.  Why can't we embed
the id to struct mem_cgroup? Is it possible to have multiple slabs with
the same combination of type, size, and memcg?

-- 
 Kirill A. Shutemov
