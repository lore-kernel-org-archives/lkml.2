Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab1DRQh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:37:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:39533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1DRQhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:37:22 -0400
Subject: Re: [RFC][PATCH 3/7] lockdep: Annotate read/write states
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1303144459.7181.42.camel@gandalf.stny.rr.com>
References: <20110417094505.865828233@chello.nl>
	 <20110417095507.026186002@chello.nl>  <20110418133405.GA2080@zhy>
	 <1303144459.7181.42.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 18:36:51 +0200
Message-ID: <1303144611.32491.878.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 12:34 -0400, Steven Rostedt wrote:
> On Mon, 2011-04-18 at 21:34 +0800, Yong Zhang wrote:
> 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > ---
> > >  include/linux/lockdep.h |  107 ++++++++++++++++++++++++++++++++++++------------
> > >  kernel/lockdep.c        |   46 ++++++++++----------
> > >  2 files changed, 105 insertions(+), 48 deletions(-)
> > > 
> > > @@ -2273,7 +2273,7 @@ mark_held_locks(struct task_struct *curr
> > >  		hlock = curr->held_locks + i;
> > >  
> > >  		usage_bit = 2 + (mark << 2); /* ENABLED */
> > > -		if (hlock->read)
> > > +		if (hlock->rw_state)
> > 
> > 		is_read(hlock->rw_state) ?
> 
> Yeah, I think this should be a is_read() or add a comment explaining why
> not.

Yeah it should be is_read().
