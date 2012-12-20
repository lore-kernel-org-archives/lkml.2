Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2LTUaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:30:12 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55553 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LTUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:30:09 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 15:30:08 EST
Date: Thu, 20 Dec 2012 12:23:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/sparse: don't check return value of alloc_bootmem
 calls
In-Reply-To: <1356030701-16284-30-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.DEB.2.00.1212201218590.29839@chino.kir.corp.google.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com> <1356030701-16284-30-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, Sasha Levin wrote:

> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6b5fb76..ae64d6e 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -403,15 +403,13 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
>  	size = PAGE_ALIGN(size);
>  	map = __alloc_bootmem_node_high(NODE_DATA(nodeid), size * map_count,
>  					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
> -	if (map) {
> -		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
> -			if (!present_section_nr(pnum))
> -				continue;
> -			map_map[pnum] = map;
> -			map += size;
> -		}
> -		return;
> +	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
> +		if (!present_section_nr(pnum))
> +			continue;
> +		map_map[pnum] = map;
> +		map += size;
>  	}
> +	return;
>  
>  	/* fallback */
>  	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {

That's not true when slab_is_available() and why would you possibly add a 
return statement right before fallback code in such cases?
