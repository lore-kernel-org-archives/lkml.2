Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab2DKNzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:55:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50515 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2DKNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:55:36 -0400
Message-ID: <4F858D53.5020402@gmail.com>
Date: Wed, 11 Apr 2012 15:55:31 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com> <1334151662.23924.240.camel@gandalf.stny.rr.com>
In-Reply-To: <1334151662.23924.240.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 03:41 PM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>
>> +static void replenish_dl_entity(struct sched_dl_entity *dl_se)
>> +{
>> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
>> +	struct rq *rq = rq_of_dl_rq(dl_rq);
>> +
>> +	/*
>> +	 * We Keep moving the deadline away until we get some
>
> s/Keep/keep/
>
>> +	 * available runtime for the entity. This ensures correct
>> +	 * handling of situations where the runtime overrun is
>> +	 * arbitrary large.
>> +	 */
>> +	while (dl_se->runtime<= 0) {
>> +		dl_se->deadline += dl_se->dl_deadline;
>> +		dl_se->runtime += dl_se->dl_runtime;
>> +	}
>> +
>> +	/*
>> +	 * At this point, the deadline really should be "in
>> +	 * the future" with respect to rq->clock. If it's
>> +	 * not, we are, for some reason, lagging too much!
>> +	 * Anyway, after having warn userspace abut that,
>> +	 * we still try to keep the things running by
>> +	 * resetting the deadline and the budget of the
>> +	 * entity.
>> +	 */
>> +	if (dl_time_before(dl_se->deadline, rq->clock)) {
>> +		WARN_ON_ONCE(1);
>> +		dl_se->deadline = rq->clock + dl_se->dl_deadline;
>> +		dl_se->runtime = dl_se->dl_runtime;
>> +	}
>> +}
>> +
>
> I just finished reviewing patches 1-5, and have yet to find anything
> wrong with them (except for these typos). I'll continue my review, and
> then I'll start testing them.
>
> Good work (so far ;-)
>
> -- Steve
>
>

Well, I tried my best to not spoil to much the work made by
Dario & Co. :-).

Anyway, thanks!

- Juri
