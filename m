Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1KXKeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:34:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1KXKeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:34:14 -0500
Date: Thu, 24 Nov 2011 11:34:12 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] mm: memcg: remove unneeded checks from
 uncharge_page()
Message-ID: <20111124103411.GH26036@tiehlicka.suse.cz>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-7-git-send-email-hannes@cmpxchg.org>
 <20111124090619.895988e7.kamezawa.hiroyu@jp.fujitsu.com>
 <20111124090639.GD6843@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124090639.GD6843@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-11-11 10:06:39, Johannes Weiner wrote:
> On Thu, Nov 24, 2011 at 09:06:19AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 23 Nov 2011 16:42:29 +0100
> > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > From: Johannes Weiner <jweiner@redhat.com>
> > > 
> > > mem_cgroup_uncharge_page() is only called on either freshly allocated
> > > pages without page->mapping or on rmapped PageAnon() pages.  There is
> > > no need to check for a page->mapping that is not an anon_vma.
> > > 
> > > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> > 
> > For making our assumption clearer to readers of codes,
> > VM_BUG_ON(page->mapping && !PageAnon(page)) please.
> 
> Yep, delta patch below.
> 
> > Anyway,
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Thanks!
> 
> ---
> From: Johannes Weiner <jweiner@redhat.com>
> Subject: mm: memcg: remove unneeded checks from uncharge_page() fix
> 
> Document page state assumptions and catch if they are violated in
> uncharge_page().
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Same here
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2f1fdc4..872dae1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2992,6 +2992,7 @@ void mem_cgroup_uncharge_page(struct page *page)
>  	/* early check. */
>  	if (page_mapped(page))
>  		return;
> +	VM_BUG_ON(page->mapping && !PageAnon(page));
>  	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
>  }
>  
> -- 
> 1.7.6.4
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
