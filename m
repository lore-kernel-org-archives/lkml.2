Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1GTHBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 03:01:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1GTHBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 03:01:07 -0400
Date: Wed, 20 Jul 2011 09:01:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: change memcg_oom_mutex to spinlock
Message-ID: <20110720070105.GC10857@tiehlicka.suse.cz>
References: <cover.1310732789.git.mhocko@suse.cz>
 <b24894c23d0bb06f849822cb30726b532ea3a4c5.1310732789.git.mhocko@suse.cz>
 <20110720145553.7703dbcb.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720145553.7703dbcb.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-07-11 14:55:53, KAMEZAWA Hiroyuki wrote:
> On Thu, 14 Jul 2011 17:29:51 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > memcg_oom_mutex is used to protect memcg OOM path and eventfd interface
> > for oom_control. None of the critical sections which it protects sleep
> > (eventfd_signal works from atomic context and the rest are simple linked
> > list resp. oom_lock atomic operations).
> > Mutex is also too heavy weight for those code paths because it triggers
> > a lot of scheduling. It also makes makes convoying effects more visible
> > when we have a big number of oom killing because we take the lock
> > mutliple times during mem_cgroup_handle_oom so we have multiple places
> > where many processes can sleep.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks!

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
