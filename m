Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab2DKQLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:11:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34670 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760038Ab2DKQL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:11:26 -0400
Message-ID: <4F85AD2A.6000402@gmail.com>
Date: Wed, 11 Apr 2012 18:11:22 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-7-git-send-email-juri.lelli@gmail.com> <1334160442.23924.257.camel@gandalf.stny.rr.com>
In-Reply-To: <1334160442.23924.257.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 06:07 PM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>
>> +static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
>> +{
>> +	/*
>> +	 * Current can't be migrated, useles to reschedule,
>
>   s/useles/useless/
>
> I feel so useles by only adding typo fixes ;-)
>

Don't know why.. but this instead sounds good to me :-P.

>> +	 * let's hope p can move out.
>> +	 */
>> +	if (rq->curr->dl.nr_cpus_allowed == 1 ||
>> +	    latest_cpu_find(rq->rd->span, rq->curr, NULL) == -1)
>> +		return;
>> +
>> +	/*
>> +	 * p is migratable, so let's not schedule it and
>> +	 * see if it is pushed or pulled somewhere else.
>> +	 */
>> +	if (p->dl.nr_cpus_allowed != 1&&
>> +	    latest_cpu_find(rq->rd->span, p, NULL) != -1)
>> +		return;
>> +
>> +	resched_task(rq->curr);
>> +}
>> +
>> +#endif /* CONFIG_SMP */
>> +
>

Thanks,

- Juri
