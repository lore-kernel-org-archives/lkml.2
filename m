Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1A1IUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:20:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35784 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab1A1IUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:20:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 17:14:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH 2/4] memcg: fix charge path for THP and allow
 early retirement
Message-Id: <20110128171447.1b5b19f3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110128075724.GB2213@cmpxchg.org>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122608.cf9be26b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128075724.GB2213@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 08:57:24 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Jan 28, 2011 at 12:26:08PM +0900, KAMEZAWA Hiroyuki wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > When THP is used, Hugepage size charge can happen. It's not handled
> > correctly in mem_cgroup_do_charge(). For example, THP can fallback
> > to small page allocation when HUGEPAGE allocation seems difficult
> > or busy, but memory cgroup doesn't understand it and continue to
> > try HUGEPAGE charging. And the worst thing is memory cgroup
> > believes 'memory reclaim succeeded' if limit - usage > PAGE_SIZE.
> > 
> > By this, khugepaged etc...can goes into inifinite reclaim loop
> > if tasks in memcg are busy.
> > 
> > After this patch 
> >  - Hugepage allocation will fail if 1st trial of page reclaim fails.
> > 
> > Changelog:
> >  - make changes small. removed renaming codes.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |   28 ++++++++++++++++++++++++----
> >  1 file changed, 24 insertions(+), 4 deletions(-)
> 
> Was there something wrong with my oneline fix?
> 
I thought your patch was against RHEL6.

> Really, there is no way to make this a beautiful fix.  The way this
> function is split up makes no sense, and the constant addition of more
> and more flags just to correctly communicate with _one callsite_
> should be an obvious hint.
> 

Your version has to depend on oom_check flag to work fine.
I think it's complicated.

Thanks,
-Kame



