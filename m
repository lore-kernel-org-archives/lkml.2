Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2JAMFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:05:22 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56981 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2JAMFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:05:20 -0400
Date: Mon, 1 Oct 2012 14:05:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: task_work_add/scheduler_tick: possible circular locking
 dependency detected
Message-ID: <20121001120515.GA21354@gmail.com>
References: <20120928113402.GA577@localhost>
 <1349088639.7780.4.camel@twins>
 <20121001115936.GA17830@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001115936.GA17830@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fengguang Wu <fengguang.wu@intel.com> wrote:

> On Mon, Oct 01, 2012 at 12:50:39PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-09-28 at 19:34 +0800, Fengguang Wu wrote:
> > > Peter,
> > > 
> > > I got the warning
> > > 
> > > [   10.412023] 
> > > [   10.412611] ======================================================
> > > [   10.413014] [ INFO: possible circular locking dependency detected ]
> > > [   10.413014] 3.6.0-rc4-00098-g7eaffe9 #402 Not tainted
> > > [   10.413014] -------------------------------------------------------
> > > [   10.413014] init/1 is trying to acquire lock:
> > > [   10.413014]  (&p->pi_lock){-.-.-.}, at: [<ffffffff81088214>] task_work_add+0x28/0x82
> > > [   10.413014] 
> > > [   10.413014] but task is already holding lock:
> > > [   10.413014]  (&rq->lock){-.-.-.}, at: [<ffffffff8109c6ea>] scheduler_tick+0x3f/0xec
> > > [   10.413014] 
> > > [   10.413014] which lock already depends on the new lock.
> > > [   10.413014] 
> > > [   10.413014] 
> > > 
> > 
> > The commit ac3d0da8f3290b3d394cdb7f50604424a7cd6092 should avoid this
> > from happening, not sure what branch its on, but it was in tip before
> > all this landed, so I guess its due to you testing sched/numa branch and
> > not a merged branch like master or auto-next.
> 
> Peter, you are right, it's tested in tip:sched/numa. linux-next is
> fine. Hmm, I should automatically test linux-next before raising the
> problem, hehe.

tip:master is well-tested and generally a couple of days fresher 
than linux-next, so in such a case where you are interested in 
tip:sched/numa you should probably test tip:master.

Thanks,

	Ingo
