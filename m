Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1HaGiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:38:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56466 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab1HaGiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:38:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 31 Aug 2011 15:30:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Brestic <abrestic@google.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Revert "memcg: add memory.vmscan_stat"
Message-Id: <20110831153025.895997bf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110831062354.GA355@redhat.com>
References: <20110829155113.GA21661@redhat.com>
	<20110830101233.ae416284.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830070424.GA13061@redhat.com>
	<20110830162050.f6c13c0c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830084245.GC13061@redhat.com>
	<20110830175609.4977ef7a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830101726.GD13061@redhat.com>
	<20110830193839.cf0fc597.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830113221.GF13061@redhat.com>
	<20110831082924.f9b20959.kamezawa.hiroyu@jp.fujitsu.com>
	<20110831062354.GA355@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 08:23:54 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Wed, Aug 31, 2011 at 08:29:24AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 30 Aug 2011 13:32:21 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
> > 
> > > On Tue, Aug 30, 2011 at 07:38:39PM +0900, KAMEZAWA Hiroyuki wrote:
> > > > On Tue, 30 Aug 2011 12:17:26 +0200
> > > > Johannes Weiner <jweiner@redhat.com> wrote:
> > > > 
> > > > > On Tue, Aug 30, 2011 at 05:56:09PM +0900, KAMEZAWA Hiroyuki wrote:
> > > > > > On Tue, 30 Aug 2011 10:42:45 +0200
> > > > > > Johannes Weiner <jweiner@redhat.com> wrote:
>
> > I'm confused. 
> > 
> > If vmscan is scanning in C's LRU,
> > 	(memcg == root) : C_scan_internal ++
> > 	(memcg != root) : C_scan_external ++
> 
> Yes.
> 
> > Why A_scan_external exists ? It's 0 ?
> > 
> > I think we can never get numbers.
> 
> Kswapd/direct reclaim should probably be accounted as A_external,
> since A has no limit, so reclaim pressure can not be internal.
> 

hmm, ok. All memory pressure from memcg/system other than the memcg itsef
is all external.

> On the other hand, one could see the amount of physical memory in the
> machine as A's limit and account global reclaim as A_internal.
> 
> I think the former may be more natural.
> 
> That aside, all memcgs should have the same statistics, obviously.
> Scripts can easily deal with counters being zero.  If items differ
> between cgroups, that would suck a lot.

So, when I improve direct-reclaim path, I need to see score in scan_internal.

How do you think about background-reclaim-per-memcg ?
Should be counted into scan_internal ?

Thanks,
-Kame

