Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1HIKAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:00:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34105 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1HIKAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:00:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 18:53:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] memcg: fix drain_all_stock crash
Message-Id: <20110809185313.dc784d70.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110809094503.GD7463@tiehlicka.suse.cz>
References: <cover.1311338634.git.mhocko@suse.cz>
	<a9244082ba28c4c2e4a6997311d5493bdaa117e9.1311338634.git.mhocko@suse.cz>
	<20110808184738.GA7749@redhat.com>
	<20110808214704.GA4396@tiehlicka.suse.cz>
	<20110808231912.GA29002@redhat.com>
	<20110809072615.GA7463@tiehlicka.suse.cz>
	<20110809093150.GC7463@tiehlicka.suse.cz>
	<20110809183216.97daf2b0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110809094503.GD7463@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011 11:45:03 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Tue 09-08-11 18:32:16, KAMEZAWA Hiroyuki wrote:
> > On Tue, 9 Aug 2011 11:31:50 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > What do you think about the half backed patch bellow? I didn't manage to
> > > test it yet but I guess it should help. I hate asymmetry of drain_lock
> > > locking (it is acquired somewhere else than it is released which is
> > > not). I will think about a nicer way how to do it.
> > > Maybe I should also split the rcu part in a separate patch.
> > > 
> > > What do you think?
> > 
> > 
> > I'd like to revert 8521fc50 first and consider total design change
> > rather than ad-hoc fix.
> 
> Agreed. Revert should go into 3.0 stable as well. Although the global
> mutex is buggy we have that behavior for a long time without any reports.
> We should address it but it can wait for 3.2.
> 

What "buggy" means here ? "problematic" or "cause OOps ?"

> > Personally, I don't like to have spin-lock in per-cpu area.
> 
> spinlock is not that different from what we already have with the bit
> lock.

maybe. The best is lockless style...but pointer in percpu cache is problem..

Thanks,
-Kame


