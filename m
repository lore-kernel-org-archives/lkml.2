Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0L3DRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 22:17:17 -0500
Received: from smtp-out.google.com ([74.125.121.67]:57208 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0L3DRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 22:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=BHvmbIaGAr3qAAcGSEFhXYj44eybuOtz64bkVcPoo/LZj2uE3XKYBi7GTP90ex4CZU
         I+AccFEz4m/68vnjitNg==
Date: Wed, 29 Dec 2010 19:17:11 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/7] Change page reference handling semantic of page
 cache
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
Message-ID: <alpine.LSU.2.00.1012291916020.14917@sister.anvils>
References: <cover.1293031046.git.minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010, Minchan Kim wrote:

> Now we increases page reference on add_to_page_cache but doesn't decrease it
> in remove_from_page_cache. Such asymmetric makes confusing about
> page reference so that caller should notice it and comment why they
> release page reference. It's not good API.
> 
> Long time ago, Hugh tried it[1] but gave up of reason which
> reiser4's drop_page had to unlock the page between removing it from
> page cache and doing the page_cache_release. But now the situation is
> changed. I think at least things in current mainline doesn't have any
> obstacles. The problem is fs or somethings out of mainline.
> If it has done such thing like reiser4, this patch could be a problem but
> they found it when compile time since we remove remove_from_page_cache.
> 
> [1] http://lkml.org/lkml/2004/10/24/140
> 
> The series configuration is following as. 
> 
> [1/7] : This patch introduces new API delete_from_page_cache.
> [2,3,4,5/7] : Change remove_from_page_cache with delete_from_page_cache.
> Intentionally I divide patch per file since someone might have a concern 
> about releasing page reference of delete_from_page_cache in 
> somecase (ex, truncate.c)
> [6/7] : Remove old API so out of fs can meet compile error when build time
> and can notice it.
> [7/7] : Change __remove_from_page_cache with __delete_from_page_cache, too.
> In this time, I made all-in-one patch because it doesn't change old behavior
> so it has no concern. Just clean up patch.
> 
> Minchan Kim (7):
>   [1/7] Introduce delete_from_page_cache
>   [2/7] fuse: Change remove_from_page_cache
>   [3/7] tlbfs: Change remove_from_page_cache
>   [4/7] swap: Change remove_from_page_cache
>   [5/7] truncate: Change remove_from_page_cache
>   [6/7] Good bye remove_from_page_cache
>   [7/7] Change __remove_from_page_cache
> 
>  fs/fuse/dev.c           |    3 +--
>  fs/hugetlbfs/inode.c    |    3 +--
>  include/linux/pagemap.h |    4 ++--
>  mm/filemap.c            |   22 +++++++++++++++++-----
>  mm/shmem.c              |    3 +--
>  mm/truncate.c           |    5 ++---
>  mm/vmscan.c             |    2 +-
>  7 files changed, 25 insertions(+), 17 deletions(-)

Acked-by: Hugh Dickins <hughd@google.com>

for all seven: thanks.
