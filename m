Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265Ab2DKNlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:41:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18470 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760151Ab2DKNlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:41:06 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=unLN5eZtZcEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=hNUH2APGU6dNFqoL-6sA:9 a=FNeZhKoXF51lM5RvYEAA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334151662.23924.240.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Wed, 11 Apr 2012 09:41:02 -0400
In-Reply-To: <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:

> +static void replenish_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +	struct rq *rq = rq_of_dl_rq(dl_rq);
> +
> +	/*
> +	 * We Keep moving the deadline away until we get some

s/Keep/keep/

> +	 * available runtime for the entity. This ensures correct
> +	 * handling of situations where the runtime overrun is
> +	 * arbitrary large.
> +	 */
> +	while (dl_se->runtime <= 0) {
> +		dl_se->deadline += dl_se->dl_deadline;
> +		dl_se->runtime += dl_se->dl_runtime;
> +	}
> +
> +	/*
> +	 * At this point, the deadline really should be "in
> +	 * the future" with respect to rq->clock. If it's
> +	 * not, we are, for some reason, lagging too much!
> +	 * Anyway, after having warn userspace abut that,
> +	 * we still try to keep the things running by
> +	 * resetting the deadline and the budget of the
> +	 * entity.
> +	 */
> +	if (dl_time_before(dl_se->deadline, rq->clock)) {
> +		WARN_ON_ONCE(1);
> +		dl_se->deadline = rq->clock + dl_se->dl_deadline;
> +		dl_se->runtime = dl_se->dl_runtime;
> +	}
> +}
> +

I just finished reviewing patches 1-5, and have yet to find anything
wrong with them (except for these typos). I'll continue my review, and
then I'll start testing them.

Good work (so far ;-)

-- Steve


