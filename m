Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab0LTQMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:12:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:54605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab0LTQMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:12:14 -0500
Subject: Re: [RFC PATCH 02/15] nohz_task: Avoid nohz task cpu as non-idle
 timer target
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292861202.22905.23.camel@gandalf.stny.rr.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-3-git-send-email-fweisbec@gmail.com>
	 <1292860078.5021.6.camel@laptop>
	 <1292861202.22905.23.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 17:12:04 +0100
Message-ID: <1292861524.5021.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 11:06 -0500, Steven Rostedt wrote:
> On Mon, 2010-12-20 at 16:47 +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > Unbound timers are preferably targeted for non idle cpu. If
> > > possible though, prioritize idle cpus over nohz task cpus,
> > > because the main point of nohz task is to avoid unnecessary
> > > timer interrupts.
> > 
> > Oh is it?
> > 
> > I'd very much expect the cpu that arms the timer to get the interrupt. I
> > mean, if the task doesn't want to get interrupted by timers,
> > _DON'T_USE_TIMERS_ to begin with.
> > 
> > So no, don't much like this at all.
> 
> I think this comes from other tasks on other CPUs that are using timers.

Tasks on other CPUs should not cause timers on this CPU, _if_ that does
happen, fix that.

> Although, I'm not sure what causes an "unbound" timer to happen. I
> thought timers usually go off on the CPU that asked for it to go off.

They do, except if you enable some weird power management feature that
migrates timers around so as to let CPUs sleep longer. But I doubt
that's the reason for this here, and if it is, just disable that.

