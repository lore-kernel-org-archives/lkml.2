Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1GIUxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 16:53:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:57684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1GIUxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 16:53:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,505,1304319600"; 
   d="scan'208";a="26000287"
Date: Sat, 9 Jul 2011 13:53:08 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: Re: [PATCH 3/3] mm/readahead: Move the check for ra_pages after
 VM_SequentialReadHint()
Message-ID: <20110709205308.GC17463@localhost>
References: <cover.1310239575.git.rprabhu@wnohang.net>
 <323ddfc402a7f7b94f0cb02bba15acb2acca786f.1310239575.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <323ddfc402a7f7b94f0cb02bba15acb2acca786f.1310239575.git.rprabhu@wnohang.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 03:41:20AM +0800, Raghavendra D Prabhu wrote:
> page_cache_sync_readahead checks for ra->ra_pages again, so moving the check after VM_SequentialReadHint.

NAK. This patch adds nothing but overheads.

> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1566,8 +1566,6 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
>  	/* If we don't want any read-ahead, don't bother */
>  	if (VM_RandomReadHint(vma))
>  		return;
> -	if (!ra->ra_pages)
> -		return;
>  
>  	if (VM_SequentialReadHint(vma)) {
>  		page_cache_sync_readahead(mapping, ra, file, offset,
> @@ -1575,6 +1573,9 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
>  		return;
>  	}
>  
> +	if (!ra->ra_pages)
> +		return;
> +

page_cache_sync_readahead() has the same

	if (!ra->ra_pages)
		return;

So the patch adds the call into page_cache_sync_readahead() just to return..

Thanks,
Fengguang
