Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1GMVC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:02:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1GMVC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:02:57 -0400
Subject: Re: [RFT][PATCH] sched, cgroup: Optimize load_balance_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Nikhil Rao <ncrao@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <CAPM31R+cS+eRaFHa2ygxF3ADYyo5Tf9R+snky3U8b5_am6Wtjg@mail.gmail.com>
References: <1310557009.2586.28.camel@twins>
	 <CAPM31R+cS+eRaFHa2ygxF3ADYyo5Tf9R+snky3U8b5_am6Wtjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 23:02:48 +0200
Message-ID: <1310590968.2586.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 10:13 -0700, Paul Turner wrote:
> Nice! The continued usage of task_groups had been irking me for a
> while but I haven't had the time to scratch the itch :).
> 
> On Wed, Jul 13, 2011 at 4:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Subject: sched, cgroup: Optimize load_balance_fair()
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed Jul 13 13:09:25 CEST 2011
> >
> > Use for_each_leaf_cfs_rq() instead of list_for_each_entry_rcu(), this
> > achieves that load_balance_fair() only iterates those task_groups that
> > actually have tasks on busiest, and that we iterate bottom-up, trying to
> > move light groups before the heavier ones.
> >
> > No idea if it will actually work out to be beneficial in practice, does
> > anybody have a cgroup workload that might show a difference one way or
> > the other?
> >
> > [ Also move update_h_load to sched_fair.c, loosing #ifdef-ery ]
> >
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Reviewed-by: Paul Turner <pjt@google.com>

So you think I should just merge it and see if any cgroup workload
dislikes it?

OK, I guess I can do that..
