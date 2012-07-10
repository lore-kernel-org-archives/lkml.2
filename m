Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab2GJRQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:16:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab2GJRQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:16:32 -0400
Date: Tue, 10 Jul 2012 19:16:29 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/11] mm: shmem: do not try to uncharge known swapcache
 pages
Message-ID: <20120710171628.GB29114@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-4-git-send-email-hannes@cmpxchg.org>
 <20120709144657.GF4627@tiehlicka.suse.cz>
 <alpine.LSU.2.00.1207091311300.1842@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207091311300.1842@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 09-07-12 13:37:39, Hugh Dickins wrote:
> On Mon, 9 Jul 2012, Michal Hocko wrote:
> > 
> > Maybe I am missing something but who does the uncharge from:
> > shmem_unuse
> >   mem_cgroup_cache_charge
> >   shmem_unuse_inode
> >     shmem_add_to_page_cache
> 
> There isn't any special uncharge for shmem_unuse(): once the swapcache
> page is matched up with its memcg, it will get uncharged by one of the
> usual routes to swapcache_free() when the page is freed: maybe in the
> call from __remove_mapping(), maybe when free_page_and_swap_cache()
> ends up calling it.
> 
> Perhaps you're worrying about error (or unfound) paths in shmem_unuse()?

Yes that was exactly my concern.

> By the time we make the charge, we know for sure that it's a shmem page,
> and make the charge appropriately; in racy cases it might get uncharged
> again in the delete_from_swap_cache().  Can the unfound case occur these
> days?  

I cannot find a change that would prevent from that.

> I'd have to think more deeply to answer that, but the charge will
> not go missing.
> 
> Hugh

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
