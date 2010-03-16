Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965890Ab0CPAGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 20:06:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43177 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965811Ab0CPAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 20:06:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Mar 2010 09:03:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kirill@shutemov.name" <kirill@shutemov.name>
Subject: Re: [PATCH 3/3] memcg: oom kill disable and oom status
Message-Id: <20100316090309.22493838.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100315150020.0cc28341.akpm@linux-foundation.org>
References: <20100312143137.f4cf0a04.kamezawa.hiroyu@jp.fujitsu.com>
	<20100312143435.e648e361.kamezawa.hiroyu@jp.fujitsu.com>
	<20100312143753.420e7ae7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100315150020.0cc28341.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 15:00:20 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 12 Mar 2010 14:37:53 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > 
> > I haven't get enough comment to this patch itself. But works well.
> > Feel free to request me if you want me to change some details.
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > This adds a feature to disable oom-killer for memcg, if disabled,
> > of course, tasks under memcg will stop.
> > 
> > But now, we have oom-notifier for memcg. And the world around
> > memcg is not under out-of-memory. memcg's out-of-memory just
> > shows memcg hits limit. Then, administrator or
> > management daemon can recover the situation by
> > 	- kill some process
> > 	- enlarge limit, add more swap.
> > 	- migrate some tasks
> > 	- remove file cache on tmps (difficult ?)
> > 
> > Unlike OOM-Kill by the kernel, the users can take snapshot or coredump
> > of guilty process, cgroups.
> > 
> 
> Looks complicated.
> 
In code, hooks are in
	- usage is reduced.
	- limit is enlarged.

Maybe my explanation is bad. It's simpler than it sounds.


> > --- mmotm-2.6.34-Mar9.orig/mm/memcontrol.c
> > +++ mmotm-2.6.34-Mar9/mm/memcontrol.c
> > @@ -235,7 +235,8 @@ struct mem_cgroup {
> >  	 * mem_cgroup ? And what type of charges should we move ?
> >  	 */
> >  	unsigned long 	move_charge_at_immigrate;
> > -
> > +	/* Disable OOM killer */
> > +	unsigned long	oom_kill_disable;
> >  	/*
> >  	 * percpu counter.
> >  	 */
> 
> Would have been better to make this `int' or `bool', and put it next to
> some other 32-bit value in this struct.
> 

Sure, will fix.

-Kame


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

