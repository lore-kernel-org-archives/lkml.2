Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab2DKQH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:07:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21637 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab2DKQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:07:25 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=u5gnqKLQQImpMZ8m11gA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334160442.23924.257.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Wed, 11 Apr 2012 12:07:22 -0400
In-Reply-To: <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:

> +static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
> +{
> +	/*
> +	 * Current can't be migrated, useles to reschedule,

 s/useles/useless/

I feel so useles by only adding typo fixes ;-)

-- Steve

> +	 * let's hope p can move out.
> +	 */
> +	if (rq->curr->dl.nr_cpus_allowed == 1 ||
> +	    latest_cpu_find(rq->rd->span, rq->curr, NULL) == -1)
> +		return;
> +
> +	/*
> +	 * p is migratable, so let's not schedule it and
> +	 * see if it is pushed or pulled somewhere else.
> +	 */
> +	if (p->dl.nr_cpus_allowed != 1 &&
> +	    latest_cpu_find(rq->rd->span, p, NULL) != -1)
> +		return;
> +
> +	resched_task(rq->curr);
> +}
> +
> +#endif /* CONFIG_SMP */
> +

