Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0KLNyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:54:11 -0500
Received: from mail0.unitn.it ([193.205.206.51]:54148 "EHLO mail0.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757591Ab0KLNyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:54:10 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 08:54:10 EST
Message-ID: <4CDD453A.70502@unitn.it>
Date: Fri, 12 Nov 2010 14:46:34 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [RFC][PATCH 09/22] sched: add period support for -deadline tasks
References: <1288333128.8661.137.camel@Palantir>	 <1288334050.8661.150.camel@Palantir>  <1289503054.2084.156.camel@laptop> <1289503883.6525.107.camel@Palantir>
In-Reply-To: <1289503883.6525.107.camel@Palantir>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 08:31 PM, Raistlin wrote:
> On Thu, 2010-11-11 at 20:17 +0100, Peter Zijlstra wrote:
>> On Fri, 2010-10-29 at 08:34 +0200, Raistlin wrote:
>>> Make it possible to specify a period (different or equal than
>>> deadline) for -deadline tasks.
>>>
>> I would expect it to be:
>>
>> runtime<= deadline<= period
>>
> Well, apart from that really unhappy comment/changelog, it should be
> like that in the code, and if it's not, it is what I meant and I'll
> change to that as soon as I can! :-)
>
> Since you spotted it... The biggest issue here is admission control
> test. Right now this is done against task's bandwidth, i.e.,
> sum_i(runtime_i/period_i)<=threshold, but it is unfortunately wrong...
> Or at least very, very loose, to the point of being almost useless! :-(
The point is that when the relative deadline is different from the period,
the concept of "task utilisation", or "bandwidth" becomes fuzzy at least
(I would say it becomes almost meaningless, but...).

The test with min{D,P} is technically more correct (meaning that it will
never accept unschedulable tasks), but it rejects some schedulable tasks.
As Tommaso pointed out, a more complex admission test would be needed.

> The more correct --in the sense that it at least yield a sufficient (not
> necessary!) condition-- thing to do would be
> sum_i(runtime_i/min{deadline_i,period_i})<=threshold.
>
> So, what you think we should do? Can I go for this latter option?
The one with min{} is at lest correct :)


				Luca
