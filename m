Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2GJQWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:22:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab2GJQWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:22:52 -0400
Date: Tue, 10 Jul 2012 18:22:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11] mm: memcg: remove needless !mm fixup to init_mm
 when charging
Message-ID: <20120710162249.GA29114@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-9-git-send-email-hannes@cmpxchg.org>
 <20120709152058.GK4627@tiehlicka.suse.cz>
 <20120710061021.GA6096@kernel>
 <20120710062104.GA19223@tiehlicka.suse.cz>
 <20120710065448.GB6096@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710065448.GB6096@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-07-12 14:54:48, Wanpeng Li wrote:
> On Tue, Jul 10, 2012 at 08:21:04AM +0200, Michal Hocko wrote:
> >On Tue 10-07-12 14:10:21, Wanpeng Li wrote:
> >> On Mon, Jul 09, 2012 at 05:20:58PM +0200, Michal Hocko wrote:
> >> >On Thu 05-07-12 02:45:00, Johannes Weiner wrote:
> >> >> It does not matter to __mem_cgroup_try_charge() if the passed mm is
> >> >> NULL or init_mm, it will charge the root memcg in either case.
> >> 
> >> You can also change the comment in __mem_cgroup_try_charge :
> >> 
> >> "if so charge the init_mm" => "if so charge the root memcg"
> >
> >This is already in place:
> >"
> >If mm is NULL and the caller doesn't pass a valid memcg pointer, that is
> >treated as a charge to root_mem_cgroup.
> >"
> 
> IIUC, if still keep comment "if so charge the init_mm" is not correct,
> since pages in pagecache aren't mapped into any processes' ptes, 
> so mm is NULL, and these pages which in pagecache are not belong 
> to init_mm, the comment should be changed. :-)

Fair enough. I guess Johannes will change that in the next post.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
