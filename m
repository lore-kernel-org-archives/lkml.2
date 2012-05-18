Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967894Ab2ERJcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:32:05 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36036 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965511Ab2ERJcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:32:00 -0400
Date: Fri, 18 May 2012 12:31:49 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Joonsoo Kim <js1304@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/4] slub: use __SetPageSlab function to set PG_slab
 flag
In-Reply-To: <1337269668-4619-4-git-send-email-js1304@gmail.com>
Message-ID: <alpine.LFD.2.02.1205181231440.3899@tux.localdomain>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com> <1337269668-4619-4-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Joonsoo Kim wrote:

> To set page-flag, using SetPageXXXX() and __SetPageXXXX() is more
> understandable and maintainable. So change it.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index c38efce..69342fd 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1369,7 +1369,7 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
>  
>  	inc_slabs_node(s, page_to_nid(page), page->objects);
>  	page->slab = s;
> -	page->flags |= 1 << PG_slab;
> +	__SetPageSlab(page);
>  
>  	start = page_address(page);

Applied
