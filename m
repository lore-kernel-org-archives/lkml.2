Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2DWLeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:34:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40908 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2DWLef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:34:35 -0400
Message-ID: <1335180849.28150.121.camel@twins>
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
Date: Mon, 23 Apr 2012 13:34:09 +0200
In-Reply-To: <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> +       /*
> +        * At this point, the deadline really should be "in
> +        * the future" with respect to rq->clock. If it's
> +        * not, we are, for some reason, lagging too much!
> +        * Anyway, after having warn userspace abut that,
> +        * we still try to keep the things running by
> +        * resetting the deadline and the budget of the
> +        * entity.
> +        */
> +       if (dl_time_before(dl_se->deadline, rq->clock)) {
> +               WARN_ON_ONCE(1);

Doing printk() and friends from scheduler context isn't actually safe
and can lock up your machine.. there's a printk_sched() that
maybe-sorta-kinda can get your complaints out..

> +               dl_se->deadline = rq->clock + dl_se->dl_deadline;
> +               dl_se->runtime = dl_se->dl_runtime;
> +       } 
