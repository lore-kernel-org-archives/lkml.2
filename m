Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1HYI3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 04:29:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53678 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab1HYI3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 04:29:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Aug 2011 17:21:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
Message-Id: <20110825172140.eb34809f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110825082049.GC3286@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
	<1314138000-2049-4-git-send-email-tj@kernel.org>
	<20110825093958.75b95bd8.kamezawa.hiroyu@jp.fujitsu.com>
	<20110825082049.GC3286@htj.dyndns.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 10:20:49 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello, KAMEZAWA.
> 

> > > @@ -5460,8 +5460,9 @@ static void mem_cgroup_clear_mc(void)
> > >  
> > >  static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
> > >  				struct cgroup *cgroup,
> > > -				struct task_struct *p)
> > > +				struct cgroup_taskset *tset)
> > >  {
> > > +	struct task_struct *p = cgroup_taskset_first(tset);
> > >  	int ret = 0;
> > >  	struct mem_cgroup *mem = mem_cgroup_from_cont(cgroup);
> > >  
> > 
> > Ah..hmm. I think this doesn't work as expected for memcg.
> > Maybe code like this will be required.
> 
> Hmmm... the above is basically identity transformation of the existing
> code.  If the above is broken, the current code is broken too.  Is it?
> 
Current code is not broken.

mem_cgroup_can_attach(....., task) need to do real job only when task->mm->owner
== task. In this modification, you pass a set of task at once.
So, mem_cgroup_can_attach() need to check _all_ tasks in tset rather than a
first task in tset. please scan and find mm->owner.

Anyway, if you merge this onto mm-tree first, I think I can have time to
write a fix up if complicated.

Thanks,
-Kame

