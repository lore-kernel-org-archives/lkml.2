Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1E3VeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 17:34:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:45833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1E3VeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 17:34:24 -0400
Subject: Re: Very high CPU load when idle with 3.0-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110530212833.GS2668@linux.vnet.ibm.com>
References: <20110530055924.GA9169@brouette>
	 <1306755291.1200.2872.camel@twins>
	 <20110530162354.GQ2668@linux.vnet.ibm.com>
	 <1306775989.2497.527.camel@laptop>
	 <20110530212833.GS2668@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 May 2011 23:33:39 +0200
Message-ID: <1306791219.23844.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 14:28 -0700, Paul E. McKenney wrote:
> On Mon, May 30, 2011 at 07:19:49PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-05-30 at 09:23 -0700, Paul E. McKenney wrote:
> > >         sp.sched_priority = RCU_KTHREAD_PRIO;
> > >         sched_setscheduler_nocheck(t, SCHED_FIFO, &sp); 
> > 
> > Why are those things RT tasks anyway? The old ksoftirq runs as a regular
> > task. And once you start boosting things you can boost this into FIFO as
> > well...
> > 
> > just wondering..
> 
> Because priority boosting doesn't help unless the callbacks also run
> RT priority.
> 
> I could make it so that they ran as normal tasks if !RCU_BOOST, but
> they would still need to run as RT tasks for RCU_BOOST.  I figured
> running them the same way in both cases would be simpler.

Ah, I thought you'd boost the threads along with the waiters, to the
same prio so that they wouldn't disturb higher priority tasks for no
reason.
