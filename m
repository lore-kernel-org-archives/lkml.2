Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1BMMwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 07:52:24 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40495 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab1BMMwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 07:52:21 -0500
Date: Sun, 13 Feb 2011 18:22:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, lizf@cn.fujitsu.com, Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH] cgroup: Fix cgroup_subsys::exit callback
Message-ID: <20110213125215.GB23919@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
 <1295534345.28776.175.camel@laptop>
 <1296646160.26581.315.camel@laptop>
 <20110202115012.GA16409@balbir.in.ibm.com>
 <1296650792.26581.319.camel@laptop>
 <20110202190251.GB16409@balbir.in.ibm.com>
 <1297095033.13327.46.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1297095033.13327.46.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-02-07 17:10:33]:

> On Thu, 2011-02-03 at 00:32 +0530, Balbir Singh wrote:
> > > No, just fixed. The callback as it exists isn't useful and leads to
> > > hacks like the above.
> 
> ---
> Subject: cgroup: Fix cgroup_subsys::exit callback
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Feb 07 17:02:20 CET 2011
> 
> Make the ::exit method act like ::attach, it is after all very nearly
> the same thing.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
> Index: linux-2.6/include/linux/cgroup.h
> ===================================================================
> --- linux-2.6.orig/include/linux/cgroup.h
> +++ linux-2.6/include/linux/cgroup.h
> @@ -474,7 +474,8 @@ struct cgroup_subsys {
>  			struct cgroup *old_cgrp, struct task_struct *tsk,
>  			bool threadgroup);
>  	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
> -	void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
> +	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
> +			struct cgroup *old_cgrp, struct task_struct *task);

The effective change I see

1. mutex_lock() being held
2. Old cgroup being passed as a part of the notification

Is 1 required? I don't see anything in the changelog. For (2), I don't
see it being used, is the use in the scheduler cgroup path/patch?

-- 
	Three Cheers,
	Balbir
