Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab2DWL5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:57:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61269 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2DWL53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:57:29 -0400
Message-ID: <4F9543A4.5000705@gmail.com>
Date: Mon, 23 Apr 2012 13:57:24 +0200
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
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com> <1335180849.28150.121.camel@twins>
In-Reply-To: <1335180849.28150.121.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 01:34 PM, Peter Zijlstra wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>> +       /*
>> +        * At this point, the deadline really should be "in
>> +        * the future" with respect to rq->clock. If it's
>> +        * not, we are, for some reason, lagging too much!
>> +        * Anyway, after having warn userspace abut that,
>> +        * we still try to keep the things running by
>> +        * resetting the deadline and the budget of the
>> +        * entity.
>> +        */
>> +       if (dl_time_before(dl_se->deadline, rq->clock)) {
>> +               WARN_ON_ONCE(1);
>
> Doing printk() and friends from scheduler context isn't actually safe
> and can lock up your machine.. there's a printk_sched() that
> maybe-sorta-kinda can get your complaints out..
>

Thanks! I'll look at it.
  
>> +               dl_se->deadline = rq->clock + dl_se->dl_deadline;
>> +               dl_se->runtime = dl_se->dl_runtime;
>> +       }

- Juri
