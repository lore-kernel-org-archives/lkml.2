Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2ATAaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:30:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43979 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2ATAap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:30:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 Jan 2012 09:29:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH] memcg: remove unnecessary thp check at page stat
 accounting
Message-Id: <20120120092928.d6514341.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120119093410.GB13932@tiehlicka.suse.cz>
References: <20120119161445.b3a8a9d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120119093410.GB13932@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012 10:34:10 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 19-01-12 16:14:45, KAMEZAWA Hiroyuki wrote:
> > Thank you very much for reviewing previous RFC series.
> > This is a patch against memcg-devel and linux-next (can by applied without HUNKs).
> > 
> > ==
> > 
> > From 64641b360839b029bb353fbd95f7554cc806ed05 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Thu, 12 Jan 2012 16:08:33 +0900
> > Subject: [PATCH] memcg: remove unnecessary thp check in mem_cgroup_update_page_stat()
> > 
> > commit 58b318ecf(memcg-devel)
> >     memcg: make mem_cgroup_split_huge_fixup() more efficient
> > removes move_lock_page_cgroup() in thp-split path.
> 
> I wouldn't refer to something which will change its commit id by its
> SHA. I guess the subject is sufficient. 

> Btw. do we really need to
> mention this? Is it just to make sure that this doesn't get merged
> withtout the mentioned patch?
> 

Hmm, ok. Yes, just informing this patch depends on that patch.




> > So, We do not have to check PageTransHuge in mem_cgroup_update_page_stat
> > and fallback into the locked accounting because both move charge and thp
> > split up are done with compound_lock so they cannot race. update vs.
> > move is protected by the mem_cgroup_stealed sufficiently.
> > 
> > PageTransHuge pages shouldn't appear in this code path currently because
> > we are tracking only file pages at the moment but later we are planning
> > to track also other pages (e.g. mlocked ones).
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Other than that
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
Thank you.

-Kame

