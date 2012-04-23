Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2DWJkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:40:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:49537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2DWJkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:40:13 -0400
Message-ID: <1335173994.28150.106.camel@twins>
Subject: Re: [PATCH 03/16] sched: SCHED_DEADLINE data structures.
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
Date: Mon, 23 Apr 2012 11:39:54 +0200
In-Reply-To: <4F95229F.1050305@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	  <1333696481-3433-4-git-send-email-juri.lelli@gmail.com>
	 <1335173405.28150.102.camel@twins> <4F95229F.1050305@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 11:36 +0200, Juri Lelli wrote:
> On 04/23/2012 11:30 AM, Peter Zijlstra wrote:
> > On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> >>   /*
> >> + * This function validates the new parameters of a -deadline task.
> >> + * We ask for the deadline not being zero, and greater or equal
> >> + * than the runtime.
> >> + */
> >> +static bool
> >> +__checkparam_dl(const struct sched_param2 *prm)
> >> +{
> >> +       return prm&&  (&prm->sched_deadline) != 0&&
> >> +              (s64)(&prm->sched_deadline -&prm->sched_runtime)>= 0;
> >> +}
> >
> > Shouldn't this also include deadline == period for now?
> 
> No notion of period in 03/16. It is inserted in 08/16 and checkparam
> changed accordingly.

Ah, ok. got confused by 2/ having sched_period.
