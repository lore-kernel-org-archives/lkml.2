Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2IURd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:33:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65060 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2IURd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:33:57 -0400
Date: Fri, 21 Sep 2012 10:33:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 03/16] slab: Ignore the cflgs bit in cache creation
Message-ID: <20120921173352.GE7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-4-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347977530-29755-4-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 06:11:57PM +0400, Glauber Costa wrote:
> No cache should ever pass that as a creation flag, since this bit is
> used to mark an internal decision of the slab about object placement. We
> can just ignore this bit if it happens to be passed (such as when
> duplicating a cache in the kmem memcg patches)
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: David Rientjes <rientjes@google.com>
> ---
>  mm/slab.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index a7ed60f..ccf496c 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2373,6 +2373,7 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
>  	int err;
>  	size_t size = cachep->size;
>  
> +	flags &= ~CFLGS_OFF_SLAB;

A comment explaining why this is necessary wouldn't hurt.

Thanks.

-- 
tejun
