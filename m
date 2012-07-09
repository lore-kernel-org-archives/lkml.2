Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2GIPf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:35:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2GIPfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:35:25 -0400
Date: Mon, 9 Jul 2012 17:35:24 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] mm: memcg: charge/uncharge improvements
Message-ID: <20120709153524.GO4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-07-12 02:44:52, Johannes Weiner wrote:
> Hello,
> 
> the biggest thing is probably #1, no longer trying (and failing) to
> charge replacement pages during migration and thus compaction.  The
> rest is cleanups and tiny optimizations that move some checks out of
> the charge and uncharge core paths that do not apply to all types of
> pages alike.

Nice clean up Johannes.
Thanks!

> 
>  include/linux/memcontrol.h |   11 +--
>  mm/memcontrol.c            |  205 +++++++++++++++++++++++---------------------
>  mm/migrate.c               |   27 ++-----
>  mm/shmem.c                 |   11 ++-
>  mm/swapfile.c              |    3 +-
>  5 files changed, 124 insertions(+), 133 deletions(-)
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
