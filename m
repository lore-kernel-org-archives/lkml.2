Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab2FADOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 23:14:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48742 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab2FADOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 23:14:40 -0400
Date: Fri, 1 Jun 2012 03:14:33 +0800
From: Chen Baozi <baozich@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/memcg: apply add/del_page to lruvec
Message-ID: <20120531191433.GA14675@centos-guest>
References: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils>
 <alpine.LSU.2.00.1205132201210.6148@eggly.anvils>
 <20120530221707.GA25095@centos-guest>
 <alpine.LSU.2.00.1205311544400.4561@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205311544400.4561@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 03:58:59PM -0700, Hugh Dickins wrote:
> On Thu, 31 May 2012, baozich wrote:
> > > 
> > > In their place, mem_cgroup_page_lruvec() to decide the lruvec,
> > > previously a side-effect of add, and mem_cgroup_update_lru_size()
> > > to maintain the lru_size stats.
> > I have a stupid question. I'm not sure whether there is reduplication
> > to put both "page" and "zone" parameter in mem_cgroup_page_lruvec(),
> > for I noticed that the "struct zone *zone" parameter are usually from 
> > page_zone(page) in most cases. I think that the semantics of this function
> > is to grab the lruvec the page belongs to. So will it be ok if we pass
> > only "page" as the parameter, which I think would be cleaner? Please
> > fix me if I missed something.
> 
> I share your dislike for passing down an "unnecessary" argument,
> but I do think it's justified here.
> 
> If the zone pointer were available simply by page->zone, then yes,
> I'd agree with you that it's probably silly to pass zone separately.
> 
> But page_zone(page) is never as trivial as that, and on some memory
> layouts it can be a lookup that you'd really prefer to avoid repeating.
> 
> In every(?) case where we're using mem_cgroup_page_lruvec(), the zone
> is already known: it's just been used for spin_lock_irq(&zone->lru_lock).
> 
> And when CONFIG_CGROUP_MEM_RES_CTLR is not set, the inline function
> mem_cgroup_page_lruvec() uses only zone, not page at all: I wouldn't
> want to be slowing down that case with another page_zone(page) lookup.
> 
> Also it's somewhat academic (though not for v3.5), in that this function
> goes away in the patches I build upon it; and I expect it also to go away
> in the patches Konstantin would build upon it - mem_cgroup_page_lruvec()
> is a staging point, before we combine memcg/zone lookup with the locking.
> 
> Hugh
I see. Thanks for the detailed explaination.

Baozi
