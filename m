Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1GZMhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:37:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:38945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1GZMhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:37:15 -0400
Subject: Re: [RFC][PATCH 6/7] sched: Balance RT tasks when forked as well
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1311683732.3526.64.camel@gandalf.stny.rr.com>
References: <20110617015516.301117218@goodmis.org>
	 <20110617015919.832743148@goodmis.org>  <1311683108.24752.33.camel@twins>
	 <1311683732.3526.64.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Jul 2011 14:36:58 +0200
Message-ID: <1311683818.24752.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 08:35 -0400, Steven Rostedt wrote:
> On Tue, 2011-07-26 at 14:25 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-06-16 at 21:55 -0400, Steven Rostedt wrote:
> > > +       /* For anything but wake ups, just return the task_cpu */
> > > +       if (sd_flag != SD_BALANCE_WAKE || sd_flag != SD_BALANCE_FORK) 
> > 
> > So we call select_task_rq() with SD_BALANCE_{WAKE,EXEC,FORK}, 
> > 
> > 	(WAKE != WAKE -> 0 || WAKE != FORK -> 1) -> 1
> > 	(EXEC != WAKE -> 1 ) -> 1
> > 	(FORK != WAKE -> 1 ) -> 1
> > 
> > IOW, you never end up doing anything now.. surely you didn't mean that?!
> 
> Bah!
> 
> s/||/&&/

So you only want to rebalance on EXEC? The comment says you want to
balance on wakeups. Please as to unconfuse!?
