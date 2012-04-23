Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2DWVZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:25:10 -0400
Received: from ms01.sssup.it ([193.205.80.99]:44379 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753591Ab2DWVZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:25:09 -0400
Message-ID: <4F95C8AF.2040606@sssup.it>
Date: Mon, 23 Apr 2012 22:25:03 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com> <1335177104.28150.113.camel@twins> <4F9530F7.9010400@gmail.com>
In-Reply-To: <4F9530F7.9010400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/04/2012 11:37, Juri Lelli ha scritto:
> On 04/23/2012 12:31 PM, Peter Zijlstra wrote:
>> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>>> +       dl_se->deadline = rq->clock + dl_se->dl_deadline;
>>
>> You might want to use rq->clock_task, this clock excludes times spend in
>> hardirq context and steal-time (when paravirt).
>>
>> Then again, it might not want to use that.. but its something you might
>> want to consider and make explicit by means of a comment.
>
> Yes, I planned a consistency check for the use of clock/clock_task
> throughout the code, but it seems I then forgot it.
> Planned for the next iteration :-).

unless I'm mistaken, there are 3 repetitions of this block in 05/16:

+		dl_se->deadline = rq->clock + dl_se->dl_deadline;
+		dl_se->runtime = dl_se->dl_runtime;


perhaps enclosing them into a function (e.g., reset_from_now() or 
similar) may help to keep consistency...

Another thing: I cannot get the real difference between rq->clock and 
rq->task_clock.
If task_clock is a kind of CLOCK_MONOTONIC thing that increases only 
when the task (or any task) is scheduled, then you don't want to use 
that here.
Here you need to set the new ->deadline to an absolute time, so I guess 
the regular rq->clock is what you need, isn't it ?

Hope I didn't say too much nonsense.

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

