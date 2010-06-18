Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0FRCWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:22:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60762 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0FRCWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:22:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 18 Jun 2010 11:17:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX][PATCH -mm] fix bad call of memcg_oom_recover at cancel
 move.
Message-Id: <20100618111735.b3d64d95.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100618105741.4e596ea7.nishimura@mxp.nes.nec.co.jp>
References: <20100617172034.00ea8835.kamezawa.hiroyu@jp.fujitsu.com>
	<20100617092442.GJ4306@balbir.in.ibm.com>
	<20100618105741.4e596ea7.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 10:57:41 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > May I recommend the following change instead
> > 
> > 
> > Don't crash on a null memcg being passed, check if memcg
> > is NULL and handle the condition gracefully
> > 
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > ---
> >  mm/memcontrol.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c6ece0a..d71c488 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1370,7 +1370,7 @@ static void memcg_wakeup_oom(struct mem_cgroup *mem)
> >  
> >  static void memcg_oom_recover(struct mem_cgroup *mem)
> >  {
> > -	if (mem->oom_kill_disable && atomic_read(&mem->oom_lock))
> > +	if (mem && mem->oom_kill_disable && atomic_read(&mem->oom_lock))
> >  		memcg_wakeup_oom(mem);
> >  }
> >  
> I agree to this fix.
> 
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 

I tend to dislike band-aid in callee. but it's not important here.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>




