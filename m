Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2DSKUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:20:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab2DSKUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:20:37 -0400
Date: Thu, 19 Apr 2012 12:20:32 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: fix Bad page state after replace_page_cache
Message-ID: <20120419102031.GA15634@tiehlicka.suse.cz>
References: <alpine.LSU.2.00.1204182325350.3700@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1204182325350.3700@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-04-12 23:34:46, Hugh Dickins wrote:
> My 9ce70c0240d0 "memcg: fix deadlock by inverting lrucare nesting" put a
> nasty little bug into v3.3's version of mem_cgroup_replace_page_cache(),
> sometimes used for FUSE.  Replacing __mem_cgroup_commit_charge_lrucare()
> by __mem_cgroup_commit_charge(), I used the "pc" pointer set up earlier:
> but it's for oldpage, and needs now to be for newpage.  Once oldpage was
> freed, its PageCgroupUsed bit (cleared above but set again here) caused
> "Bad page state" messages - and perhaps worse, being missed from newpage.
> (I didn't find this by using FUSE, but in reusing the function for tmpfs.)
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks

> Cc: stable@vger.kernel.org [v3.3 only]
> ---
> 
>  mm/memcontrol.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- 3.4-rc3/mm/memcontrol.c	2012-04-15 20:47:37.151777506 -0700
> +++ linux/mm/memcontrol.c	2012-04-18 22:29:18.490639511 -0700
> @@ -3392,6 +3392,7 @@ void mem_cgroup_replace_page_cache(struc
>  	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
>  	 * LRU while we overwrite pc->mem_cgroup.
>  	 */
> +	pc = lookup_page_cgroup(newpage);
>  	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type, true);
>  }
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
