Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2L0WXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:23:07 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37089 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2L0WXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:23:05 -0500
Date: Thu, 27 Dec 2012 14:23:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm, sparse: allocate bootmem without panicing in
 sparse_mem_maps_populate_node
In-Reply-To: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.DEB.2.00.1212271422280.18214@chino.kir.corp.google.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2012, Sasha Levin wrote:

> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6b5fb76..72a0db6 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -401,7 +401,7 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
>  	}
>  
>  	size = PAGE_ALIGN(size);
> -	map = __alloc_bootmem_node_high(NODE_DATA(nodeid), size * map_count,
> +	map = __alloc_bootmem_node_high_nopanic(NODE_DATA(nodeid), size * map_count,
>  					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
>  	if (map) {
>  		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {

What tree is this series based on?  There's no 
__alloc_bootmem_node_high_nopanic() either in 3.8-rc1 nor in linux-next.
