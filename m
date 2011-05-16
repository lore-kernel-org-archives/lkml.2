Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1EPWgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 18:36:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab1EPWgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 18:36:37 -0400
Date: Mon, 16 May 2011 15:36:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 2/6] vmscan: make distinction between memcg reclaim
 and LRU list selection
Message-Id: <20110516153607.49d4dc41.akpm@linux-foundation.org>
In-Reply-To: <20110513065854.GB18610@cmpxchg.org>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
	<1305212038-15445-3-git-send-email-hannes@cmpxchg.org>
	<20110513085027.25b25a47.kamezawa.hiroyu@jp.fujitsu.com>
	<20110513065854.GB18610@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 08:58:54 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> > > @@ -154,16 +158,24 @@ static LIST_HEAD(shrinker_list);
> > >  static DECLARE_RWSEM(shrinker_rwsem);
> > >  
> > >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > > -#define scanning_global_lru(sc)	(!(sc)->mem_cgroup)
> > > +static bool global_reclaim(struct scan_control *sc)
> > > +{
> > > +	return !sc->memcg;
> > > +}
> > > +static bool scanning_global_lru(struct scan_control *sc)
> > > +{
> > > +	return !sc->current_memcg;
> > > +}
> > 
> > 
> > Could you add comments ?

oy, that's my job.

> Yes, I will.

> +static bool global_reclaim(struct scan_control *sc) { return 1; }
> +static bool scanning_global_lru(struct scan_control *sc) { return 1; }

s/1/true/

And we may as well format the functions properly?

And it would be nice for the names of the functions to identify what
subsystem they belong to: memcg_global_reclaim() or such.  Although
that's already been a bit messed up in memcg (and in the VM generally).

