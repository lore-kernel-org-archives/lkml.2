Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1HRGuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:50:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50361 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1HRGue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:50:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Aug 2011 15:42:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v5 2/6]  memcg: stop vmscan when enough done.
Message-Id: <20110818154259.6b4adf09.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110818062722.GB23056@tiehlicka.suse.cz>
References: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
	<20110809190933.d965888b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110810141425.GC15007@tiehlicka.suse.cz>
	<20110811085252.b29081f1.kamezawa.hiroyu@jp.fujitsu.com>
	<20110811145055.GN8023@tiehlicka.suse.cz>
	<20110817095405.ee3dcd74.kamezawa.hiroyu@jp.fujitsu.com>
	<20110817113550.GA7482@tiehlicka.suse.cz>
	<20110818085233.69dbf23b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110818062722.GB23056@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 08:27:22 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 18-08-11 08:52:33, KAMEZAWA Hiroyuki wrote:
> > On Wed, 17 Aug 2011 13:35:50 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > On Wed 17-08-11 09:54:05, KAMEZAWA Hiroyuki wrote:
> > > > On Thu, 11 Aug 2011 16:50:55 +0200
> > > > > - mem_cgroup_force_empty asks for reclaiming all pages. I guess it should be
> > > > >   OK but will have to think about it some more.
> > > > 
> > > > force_empty/rmdir() is allowed to be stopped by Ctrl-C. I think passing res->usage
> > > > is overkilling.
> > > 
> > > So, how many pages should be reclaimed then?
> > > 
> > 
> > How about (1 << (MAX_ORDER-1))/loop ?
> 
> Hmm, I am not sure I see any benefit. We want to reclaim all those
> pages why shouldn't we do it in one batch? If we use a value based on
> MAX_ORDER then we make a bigger chance that force_empty fails for big
> cgroups (e.g. with a lot of page cache).

Why bigger chance to fail ? retry counter is decreased only when we cannot
make any reclaim. The number passed here is not problem against the faiulre.

I don't like very long vmscan which cannot be stopped by Ctrl-C.


> Anyway, if we want to mimic the previous behavior then we should use
> something like nr_nodes * SWAP_CLUSTER_MAX (the above value would be
> sufficient for up to 32 nodes).
> 

agreed.

Thanks,
-Kame


