Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2JSTuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:50:40 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:42192 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758313Ab2JSTuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:50:39 -0400
Date: Fri, 19 Oct 2012 19:50:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 15/18] Aggregate memcg cache values in slabinfo
In-Reply-To: <1350656442-1523-16-git-send-email-glommer@parallels.com>
Message-ID: <0000013a7a93cb72-588b2a69-ebb0-4b5f-9040-102800d3bef4-000000@email.amazonses.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-16-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Glauber Costa wrote:

> +
> +/*
> + * We use suffixes to the name in memcg because we can't have caches
> + * created in the system with the same name. But when we print them
> + * locally, better refer to them with the base name
> + */
> +static inline const char *cache_name(struct kmem_cache *s)
> +{
> +	if (!is_root_cache(s))
> +		return s->memcg_params->root_cache->name;
> +	return s->name;
> +}

Could we avoid this uglyness? You can ID a slab cache by combining a memcg
pointer and a slabname.

