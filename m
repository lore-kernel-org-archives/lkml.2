Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1LLNLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:11:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab1LLNLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:11:20 -0500
Date: Mon, 12 Dec 2011 14:11:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg: keep root group unchanged if fail to create
 new
Message-ID: <20111212131118.GA15249@tiehlicka.suse.cz>
References: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
 <alpine.LSU.2.00.1112111520510.2297@eggly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1112111520510.2297@eggly>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 11-12-11 15:39:43, Hugh Dickins wrote:
> On Sun, 11 Dec 2011, Hillf Danton wrote:
> 
> > If the request is not to create root group and we fail to meet it,
> > we'd leave the root unchanged.
> 
> I didn't understand that at first: please say "we should" rather
> than "we'd", which I take to be an abbreviation for "we would".
> 
> > 
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> 
> Yes indeed, well caught:
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> I wonder what was going through the author's mind when he wrote it
> that way?  I wonder if it's one of those bugs that creeps in when
> you start from a perfectly functional patch, then make refinements
> to suit feedback from reviewers.
> 
> On which topic: wouldn't this patch be better just to move the
> "root_mem_cgroup = memcg;" two lines lower down (and of course
> remove free_out's "root_mem_cgroup = NULL;" as you already did)?

Yes would look nicer.

> I can't see mem_cgroup_soft_limit_tree_init() relying on
> root_mem_cgroup at all.

It doesn't but it still needs some love to handle error case properly
AFAICS. We do not deallocate softlimit trees for nodes that succeeded.

[...]

Hilf could you update the patch please?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
