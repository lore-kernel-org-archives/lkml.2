Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0KLR6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:58:13 -0500
Received: from mail0.unitn.it ([193.205.206.51]:42753 "EHLO mail0.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0KLR6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:58:12 -0500
Message-ID: <4CDD7F5B.7090004@unitn.it>
Date: Fri, 12 Nov 2010 18:54:35 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline tasks
References: <1288333128.8661.137.camel@Palantir>	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>	 <1289576177.6525.509.camel@Palantir> <1289577841.2084.302.camel@laptop>	 <4CDD7C65.9090400@unitn.it> <1289584295.2084.343.camel@laptop>
In-Reply-To: <1289584295.2084.343.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/10 18:51, Peter Zijlstra wrote:
> On Fri, 2010-11-12 at 18:41 +0100, Luca Abeni wrote:
>>> The problem the stochastic execution time model tries to address is the
>>> WCET computation mess, WCET computation is hard and often overly
>>> pessimistic, resulting in under-utilized systems.
>> [...]
>> BTW, sorry for the shameless plug, but even with the current
>> SCHED_DEADLINE you are not forced to dimension the runtime using the
>> WCET.
>
> Yes you are, it pushes the deadline back on overrun.
I think in case of overrun it postpones the deadline (by a period P), 
avoiding to execute the task until the end of the current period, right?

> The idea it to
> maintain the deadline despite overrunning your budget (up to a point).
>
> The paper we're all talking about is:
>
> A. Mills and J. Anderson, " A Stochastic Framework for Multiprocessor
> Soft Real-Time Scheduling", Proceedings of the 16th IEEE Real-Time and
> Embedded Technology and Applications Symposium, pp. 311-320, April 2010.
> http://www.cs.unc.edu/~anderson/papers/rtas10brevised.pdf
I see... This is a different approach to stochastic analysis, which 
requires modifications to the scheduler.

In the analysis I mentioned, you still enforce a maximum runtime C every 
period P, but C can be smaller than the WCET of the task. If C is larger 
than the average execution time, you can use queuing theory to find the 
probability to miss a deadline (or, the probability to finish a job in a 
time x * P).


				Luca
