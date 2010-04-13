Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0DMViI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:38:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab0DMViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:38:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=k/PgRvBnn1ZNwPhDSJVwheeYsxR+LvJee4z774Qzhb7r/5UkVZuDn+Q5OekN0l/Hb
	lBwzfiNfIcmjWgb6KbX4g==
Date: Tue, 13 Apr 2010 14:37:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/6] change alloc function in alloc_slab_page
In-Reply-To: <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com>
Message-ID: <alpine.DEB.2.00.1004131437140.8617@chino.kir.corp.google.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com> <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Minchan Kim wrote:

> alloc_slab_page never calls alloc_pages_node with -1.
> It means node's validity check is unnecessary.
> So we can use alloc_pages_exact_node instead of alloc_pages_node.
> It could avoid comparison and branch as 6484eb3e2a81807722 tried.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/slub.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b364844..9984165 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1084,7 +1084,7 @@ static inline struct page *alloc_slab_page(gfp_t flags, int node,
>  	if (node == -1)
>  		return alloc_pages(flags, order);
>  	else
> -		return alloc_pages_node(node, flags, order);
> +		return alloc_pages_exact_node(node, flags, order);
>  }
>  
>  static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)

Slub changes need to go through its maintainer, Pekka Enberg 
<penberg@cs.helsinki.fi>.
