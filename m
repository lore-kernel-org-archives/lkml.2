Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1KXAHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:07:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56805 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1KXAHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:07:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Nov 2011 09:06:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] mm: memcg: remove unneeded checks from
 uncharge_page()
Message-Id: <20111124090619.895988e7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322062951-1756-7-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-7-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 16:42:29 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Johannes Weiner <jweiner@redhat.com>
> 
> mem_cgroup_uncharge_page() is only called on either freshly allocated
> pages without page->mapping or on rmapped PageAnon() pages.  There is
> no need to check for a page->mapping that is not an anon_vma.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

For making our assumption clearer to readers of codes,
VM_BUG_ON(page->mapping && !PageAnon(page)) please.

Anyway,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  mm/memcontrol.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0d10be4..b9a3b94 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2989,8 +2989,6 @@ void mem_cgroup_uncharge_page(struct page *page)
>  	/* early check. */
>  	if (page_mapped(page))
>  		return;
> -	if (page->mapping && !PageAnon(page))
> -		return;
>  	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
>  }
>  
> -- 
> 1.7.6.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

