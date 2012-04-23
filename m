Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2DWPoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:44:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34449 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2DWPoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:44:11 -0400
Message-ID: <1335195826.28150.177.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Mon, 23 Apr 2012 17:43:46 +0200
In-Reply-To: <4F9577CF.2020400@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
	 <1335191701.28150.155.camel@twins> <4F9577CF.2020400@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 17:39 +0200, Juri Lelli wrote:
> On 04/23/2012 04:35 PM, Peter Zijlstra wrote:
> > On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> >> +static void init_dl_task_timer(struct sched_dl_entity *dl_se)
> >> +{
> >> +       struct hrtimer *timer =&dl_se->dl_timer;
> >> +
> >> +       if (hrtimer_active(timer)) {
> >> +               hrtimer_try_to_cancel(timer);
> >> +               return;
> >> +       }
> >
> > Same question I guess, how can it be active here? Also, just letting it
> > run doesn't seem like the best way out..
> >
> 
> Probably s/hrtimer_try_to_cancel/hrtimer_cancel is better.

Yeah, not sure you can do hrtimer_cancel() there though, you're holding
->pi_lock and rq->lock and have IRQs disabled. That sounds like asking
for trouble.

Anyway, if it can't happen, we don't have to fix it.. so lets answer
that first ;-)
