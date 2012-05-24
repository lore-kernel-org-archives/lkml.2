Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655Ab2EXVfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:35:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55290 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965639Ab2EXVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:35:07 -0400
Date: Thu, 24 May 2012 14:35:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V6 06/14] hugetlb: Simplify migrate_huge_page
In-Reply-To: <1334573091-18602-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205241432290.24113@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Aneesh Kumar K.V wrote:

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 97cc273..1f092db 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1414,7 +1414,6 @@ static int soft_offline_huge_page(struct page *page, int flags)
>  	int ret;
>  	unsigned long pfn = page_to_pfn(page);
>  	struct page *hpage = compound_head(page);
> -	LIST_HEAD(pagelist);
>  
>  	ret = get_any_page(page, pfn, flags);
>  	if (ret < 0)
> @@ -1429,19 +1428,11 @@ static int soft_offline_huge_page(struct page *page, int flags)
>  	}
>  
>  	/* Keep page count to indicate a given hugepage is isolated. */
> -
> -	list_add(&hpage->lru, &pagelist);
> -	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
> -				true);
> +	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);

Was this tested?  Shouldn't this be migrate_huge_page(compound_head(page), 
...)?
