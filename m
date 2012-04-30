Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2D3Tma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 15:42:30 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50365 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab2D3Tm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 15:42:29 -0400
MIME-Version: 1.0
In-Reply-To: <1334959051-18203-11-git-send-email-glommer@parallels.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com>
	<1334959051-18203-11-git-send-email-glommer@parallels.com>
Date: Mon, 30 Apr 2012 12:42:28 -0700
Message-ID: <CABCjUKDKwJMZioQPBwdiN-SUOW7VQkkBajwbKHUCSz1sdM6dQQ@mail.gmail.com>
Subject: Re: [PATCH 10/23] slab/slub: struct memcg_params
From: Suleiman Souhlal <suleiman@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 2:57 PM, Glauber Costa <glommer@parallels.com> wrote:
> For the kmem slab controller, we need to record some extra
> information in the kmem_cache structure.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>
> ---
>  include/linux/slab.h     |   15 +++++++++++++++
>  include/linux/slab_def.h |    4 ++++
>  include/linux/slub_def.h |    3 +++
>  3 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index a595dce..a5127e1 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -153,6 +153,21 @@ unsigned int kmem_cache_size(struct kmem_cache *);
>  #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>  #endif
>
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +struct mem_cgroup_cache_params {
> +       struct mem_cgroup *memcg;
> +       int id;
> +
> +#ifdef CONFIG_SLAB
> +       /* Original cache parameters, used when creating a memcg cache */
> +       size_t orig_align;
> +       atomic_t refcnt;
> +
> +#endif
> +       struct list_head destroyed_list; /* Used when deleting cpuset cache */

s,cpuset,memcg,

Sorry about that.

-- Suleiman
