Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2KZVf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:35:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49362 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2KZVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:35:25 -0500
Date: Mon, 26 Nov 2012 22:35:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Message-ID: <20121126213516.GD12602@dhcp22.suse.cz>
References: <20121115073420.GA19036@lizard.sbx05977.paloaca.wayport.net>
 <alpine.DEB.2.00.1211142351420.4410@chino.kir.corp.google.com>
 <20121115085224.GA4635@lizard>
 <alpine.DEB.2.00.1211151303510.27188@chino.kir.corp.google.com>
 <50A60873.3000607@parallels.com>
 <alpine.DEB.2.00.1211161157390.2788@chino.kir.corp.google.com>
 <50A6AC48.6080102@parallels.com>
 <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com>
 <50AA3ABF.4090803@parallels.com>
 <alpine.DEB.2.00.1211200950120.4200@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211200950120.4200@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry to jump in that late]

On Tue 20-11-12 10:02:45, David Rientjes wrote:
> On Mon, 19 Nov 2012, Glauber Costa wrote:
> 
> > >> In the case I outlined below, for backwards compatibility. What I
> > >> actually mean is that memcg *currently* allows arbitrary notifications.
> > >> One way to merge those, while moving to a saner 3-point notification, is
> > >> to still allow the old writes and fit them in the closest bucket.
> > >>
> > > 
> > > Yeah, but I'm wondering why three is the right answer.
> > > 
> > 
> > This is unrelated to what I am talking about.
> > I am talking about pre-defined values with a specific event meaning (in
> > his patchset, 3) vs arbitrary numbers valued in bytes.
> > 
> 
> Right, and I don't see how you can map the memcg thresholds onto Anton's 
> scheme that heavily relies upon reclaim activity; what bucket does a 
> threshold of 48MB in a memcg with a limit of 64MB fit into?
> Perhaps you have some formula in mind that would do this, but I don't
> see how it works correctly without factoring in configuration options
> (memory compaction), type of allocation (GFP_ATOMIC won't trigger
> Anton's reclaim scheme like GFP_KERNEL), altered min_free_kbytes, etc.
> 
> This begs the question of whether the new cgroup should be considered as a 
> replacement for memory thresholds within memcg in the first place; 
> certainly both can coexist just fine.

Absolutely agreed. Yes those two things are inherently different.
Information that "you have passed half of your limit" is something
totally different than "you should slow down". Although I am not
entirely sure what the first is one good for (to be honest), but I
believe there are users out there.

I do not think that mixing those two makes much sense. They have
different usecases and until we have users for the thresholds one we
should keep it.

[...]

Thanks
-- 
Michal Hocko
SUSE Labs
