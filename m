Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1A0Xzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:55:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45958 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1A0Xzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:55:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 08:49:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [patch 3/3] memcg: never OOM when charging huge pages
Message-Id: <20110128084928.8ffb68e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110128084540.3a5511ba.nishimura@mxp.nes.nec.co.jp>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110121154430.70d45f15.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127103438.GC2401@cmpxchg.org>
	<20110127134703.GB14309@cmpxchg.org>
	<20110128084540.3a5511ba.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 08:45:40 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Thu, 27 Jan 2011 14:47:03 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > Huge page coverage should obviously have less priority than the
> > continued execution of a process.
> > 
> > Never kill a process when charging it a huge page fails.  Instead,
> > give up after the first failed reclaim attempt and fall back to
> > regular pages.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/memcontrol.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 17c4e36..2945649 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1890,6 +1890,13 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> >  	int csize = max(CHARGE_SIZE, (unsigned long) page_size);
> >  
> >  	/*
> > +	 * Do not OOM on huge pages.  Fall back to regular pages after
> > +	 * the first failed reclaim attempt.
> > +	 */
> > +	if (page_size > PAGE_SIZE)
> > +		oom = false;
> > +
> > +	/*
> >  	 * Unlike gloval-vm's OOM-kill, we're not in memory shortage
> >  	 * in system level. So, allow to go ahead dying process in addition to
> >  	 * MEMDIE process.
> > -- 
> > 1.7.3.5
> > 
> __mem_cgroup_try_charge() has "oom" switch already, so I prefer making callers
> use the switch properly by themselves.
> 

Okay, will do.

-Kame

