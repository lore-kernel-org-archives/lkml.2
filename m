Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2DWPhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:37:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52967 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2DWPhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:37:13 -0400
Message-ID: <4F957723.2000000@gmail.com>
Date: Mon, 23 Apr 2012 17:37:07 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com> <1335194148.28150.175.camel@twins>
In-Reply-To: <1335194148.28150.175.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:15 PM, Peter Zijlstra wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>> +static
>> +int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
>> +{
>> +       int dmiss = dl_time_before(dl_se->deadline, rq->clock);
>> +       int rorun = dl_se->runtime<= 0;
>> +
>> +       if (!rorun&&  !dmiss)
>> +               return 0;
>> +
>> +       /*
>> +        * If we are beyond our current deadline and we are still
>> +        * executing, then we have already used some of the runtime of
>> +        * the next instance. Thus, if we do not account that, we are
>> +        * stealing bandwidth from the system at each deadline miss!
>> +        */
>> +       if (dmiss) {
>> +               dl_se->runtime = rorun ? dl_se->runtime : 0;
>> +               dl_se->runtime -= rq->clock - dl_se->deadline;
>> +       }
>
> So ideally this can't happen, but since we already leak time from the
> system through means of hardirq / kstop / context-switch-overhead /
> clock-jitter etc.. we avoid the error accumulating?
>

Yep, seems fair :-).
  
>> +
>> +       return 1;
>> +}
>
>

Thanks,

- Juri
