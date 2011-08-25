Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1HYIpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 04:45:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59424 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1HYIpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 04:45:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Aug 2011 17:37:50 +0900
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
Message-Id: <20110825173750.4959360f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAOS58YPM=cuWjAF+VJ4QJ8bnRcVtaDCVXBJCpdWg+2=2GmnKrA@mail.gmail.com>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
	<1314138000-2049-4-git-send-email-tj@kernel.org>
	<20110825093958.75b95bd8.kamezawa.hiroyu@jp.fujitsu.com>
	<20110825082049.GC3286@htj.dyndns.org>
	<20110825172140.eb34809f.kamezawa.hiroyu@jp.fujitsu.com>
	<CAOS58YPM=cuWjAF+VJ4QJ8bnRcVtaDCVXBJCpdWg+2=2GmnKrA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 10:40:06 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Aug 25, 2011 at 10:21 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> Hmmm... the above is basically identity transformation of the existing
> >> code.  If the above is broken, the current code is broken too.  Is it?
> >>
> > Current code is not broken.
> 
> Trust me.  If the posted code is broken, the current code is too. It
> is an IDENTITY transformation.
> 
> > mem_cgroup_can_attach(....., task) need to do real job only when task->mm->owner
> > == task. In this modification, you pass a set of task at once.
> 
> Before the change, cgroup would migrate multiple tasks all the same
> but memcg wouldn't have noticed it unless it opted in explicitly using
> [can_]attach_task(). When multiple tasks were moving, [can_]attach()
> would only be called with the leader whether the leader actually is
> changing cgroup or not. The interface sucked and it wasn't properly
> documented but that's what was happening. The interface change is just
> making the breakage obvious - +1 for the new interface. :)
> 
Thank you for clarification. Ok, current code is broken.


> > So, mem_cgroup_can_attach() need to check _all_ tasks in tset rather than a
> > first task in tset. please scan and find mm->owner.
> >
> > Anyway, if you merge this onto mm-tree first, I think I can have time to
> > write a fix up if complicated.
> 
> As for specific merging order, it shouldn't matter all that much but
> if you wanna backport fixes for -stable, maybe it would make more
> sense to sequence the fix before this change.
> 
> Thank you.

Sure. IIUC, the case thread_leader != mm->owner is uncommon. 
I'll consider a fix onto your fix, first.

I'll cosinder a fix for stable tree if someone requests.

Thanks,
-Kame

