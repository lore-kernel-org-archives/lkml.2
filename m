Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1H2IHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:07:39 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58914 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab1H2IH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:07:26 -0400
Date: Mon, 29 Aug 2011 10:07:11 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
Message-ID: <20110829080711.GC32114@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
 <CALWz4iwChnacF061L9vWo7nEA7qaXNJrK=+jsEe9xBtvEBD9MA@mail.gmail.com>
 <20110811210914.GB31229@cmpxchg.org>
 <CALWz4iwJfyWRineMy+W02YBvS0Y=Pv1y8Rb=8i5R=vUCfrO+iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALWz4iwJfyWRineMy+W02YBvS0Y=Pv1y8Rb=8i5R=vUCfrO+iQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 12:15:57AM -0700, Ying Han wrote:
> On Thu, Aug 11, 2011 at 2:09 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Thu, Aug 11, 2011 at 01:39:45PM -0700, Ying Han wrote:
> > > Please consider including the following patch for the next post. It causes
> > > crash on some of the tests where sc->mem_cgroup is NULL (global kswapd).
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index b72a844..12ab25d 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -2768,7 +2768,8 @@ loop_again:
> > >                          * Do some background aging of the anon list, to
> > > give
> > >                          * pages a chance to be referenced before
> > > reclaiming.
> > >                          */
> > > -                       if (inactive_anon_is_low(zone, &sc))
> > > +                       if (scanning_global_lru(&sc) &&
> > > +                                       inactive_anon_is_low(zone, &sc))
> > >                                 shrink_active_list(SWAP_CLUSTER_MAX, zone,
> > >                                                         &sc, priority, 0);
> >
> > Thanks!  I completely overlooked this one and only noticed it after
> > changing the arguments to shrink_active_list().
> >
> > On memcg configurations, scanning_global_lru() will essentially never
> > be true again, so I moved the anon pre-aging to a separate function
> > that also does a hierarchy loop to preage the per-memcg anon lists.
> >
> > I hope to send out the next revision soon.
> 
> Also, please consider to fold in the following patch as well. It fixes
> the root cgroup lru accounting and we could easily trigger OOM while
> doing some swapoff test w/o it.

This makes perfect sense.  I'll incorporate this and add your
sign-offs to the original patch.  Thanks very to the both of you and
sorry for the inconvenience.
