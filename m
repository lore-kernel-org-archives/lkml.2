Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1HZCs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 22:48:29 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46490 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab1HZCs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 22:48:28 -0400
Date: Thu, 25 Aug 2011 19:48:22 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, paul@paulmenage.org,
        lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
Message-ID: <20110826024822.GA1919@count0.beaverton.ibm.com>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <1314312192-26885-4-git-send-email-tj@kernel.org>
 <20110826023818.GC3457@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826023818.GC3457@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 07:38:18PM -0700, Matt Helsley wrote:
> On Fri, Aug 26, 2011 at 12:43:09AM +0200, Tejun Heo wrote:
> > Currently, there's no way to pass multiple tasks to cgroup_subsys
> > methods necessitating the need for separate per-process and per-task
> > methods.  This patch introduces cgroup_taskset which can be used to
> > pass multiple tasks and their associated cgroups to cgroup_subsys
> > methods.
> 
> This will be the third iterator-ish pattern in the cgroup code.
> It's not your fault but it does seem a bit much to have:
> 
> 	1) When we need to iterate over all tasks in the cgroup and
> 	don't mind holding the css set lock:
> 		void cgroup_iter_start(cgroup, iterator)
> 		task cgroup_iter_next(cgroup, iterator)
> 		void cgroup_iter_end(cgroup, iterator)
> 
> 	2) For subsystem methods when we're iterating over a subset of
> 	tasks that may or may not be in the cgroup (e.g. for can_attach)
> 	-- use cgroup_tasksets:
> 		task cgroup_taskset_first(tset)
> 		task cgroup_taskset_next(tset)
> 
> 	3) An iterator over all the tasks which doesn't hold the css set
> 	lock:
> 		struct cgroup_scanner {
> 			struct cgroup *cg;
> 			int (*test_task)(struct task_struct *p,
> 					struct cgroup_scanner *scan);
> 			void (*process_task)(struct task_struct *p,
> 					struct cgroup_scanner *scan);
> 			struct ptr_heap *heap;
> 			void *data;
> 		};
> 	This is only used in cpuset code so far. Are other cgroup
> 	patches planning on making use of it?
> 
> Is there a sane way to merge all this?
> 
> Perhaps we could drop the iterator interfaces in 1) and 2) and replace

Oops! I meant to suggest dropping interfaces 1) and 3).

Cheers,
	-Matt
