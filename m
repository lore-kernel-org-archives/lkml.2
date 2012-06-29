Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2F2SkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:40:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55372 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2F2SkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:40:09 -0400
Date: Fri, 29 Jun 2012 11:32:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH for -3.5] memblock: free allocated
 memblock_reserved_regions later
Message-ID: <20120629183233.GC21048@google.com>
References: <CAE9FiQXqb4NVnWeJR75+gfwCkKMtBh2GDwoSijPf4JEezfqcnQ@mail.gmail.com>
 <1340994477-3122-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340994477-3122-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

Just one nitpick.

On Fri, Jun 29, 2012 at 11:27:57AM -0700, Yinghai Lu wrote:
>  /**
>   * memblock_double_array - double the size of the memblock regions array
>   * @type: memblock type of the regions array being doubled
> @@ -204,6 +192,7 @@ static int __init_memblock memblock_doub
>  						phys_addr_t new_area_size)
>  {
>  	struct memblock_region *new_array, *old_array;
> +	phys_addr_t old_alloc_size, new_alloc_size;
>  	phys_addr_t old_size, new_size, addr;
>  	int use_slab = slab_is_available();
>  	int *in_slab;
> @@ -217,6 +206,12 @@ static int __init_memblock memblock_doub
>  	/* Calculate new doubled size */
>  	old_size = type->max * sizeof(struct memblock_region);
>  	new_size = old_size << 1;
> +	/*
> +	 * We need to allocated new one align to PAGE_SIZE,
> +	 *  so late could free them completely.

An extra space and probably "so we can free them completely later"
fits better.

Thank you!

-- 
tejun
