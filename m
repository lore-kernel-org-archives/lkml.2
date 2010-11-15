Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab0KOTus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:50:48 -0500
Received: from fafnir.cs.unc.edu ([152.2.129.90]:60930 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936Ab0KOTur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:50:47 -0500
Message-ID: <4CE18EC0.8070802@cs.unc.edu>
Date: Mon, 15 Nov 2010 14:49:20 -0500
From: "James H. Anderson" <anderson@cs.unc.edu>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Luca Abeni <luca.abeni@unitn.it>
CC: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
        paulmck <paulmck@linux.vnet.ibm.com>,
        Bjoern Brandenburg <bbb@email.unc.edu>
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline tasks
References: <1289588215.6525.697.camel@Palantir> <80992760-24F2-42AE-AF2D-15727F6A1C81@email.unc.edu> <4CE17DD2.3060807@cs.unc.edu> <4CE18895.8060101@unitn.it>
In-Reply-To: <4CE18895.8060101@unitn.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/15/2010 2:23 PM, Luca Abeni wrote:
> Hi James,
>
> On 15/11/10 19:37, James H. Anderson wrote:
> [...]
>>>> The problem the stochastic execution time model tries to address is 
>>>> the
>>>> WCET computation mess, WCET computation is hard and often overly
>>>> pessimistic, resulting in under-utilized systems.
>>>>
>>> I know, and it's very reasonable. The point I'm trying to make is that
>>> resource reservation tries to address the very same issue.
>>> I am all but against this model, just want to be sure it's not too much
>>> in conflict to the other features we have, especially with resource
>>> reservation. Especially considering that --if I got the whole thing
>>> about this scheduler right-- resource reservation is something we 
>>> really
>>> want, and I think UNC people would agree here, since I heard Bjorn
>>> stating this very clear both in Dresden and in Dublin. :-)
>>>
>>> BTW, I'm adding them to the Cc, seems fair, and more useful than all
>>> this speculation! :-P
>>>
>>> Bjorn, Jim, sorry for bothering. If you're interested, this is the very
>>> beginning of the whole thread:
>>> http://lkml.org/lkml/2010/10/29/67
> [...]
>> If you're talking about our most recent "stochastic" paper, it is about
>> supporting
>> soft real-time task systems on a multiprocessor where resource
>> reservations are
>> used. The main result of the paper is that if you provision the
>> reservation for a
>> task slightly higher than it's average-case execution time, and if you
>> use a
>> scheduling algorithm (like global EDF) that ensures bounded tardiness
>> (w.r.t.
>> these reservations), then the task's expected tardiness will be bounded
>> and the
>> expected bound does not depend on worst-case execution times. I'm not
>> sure if
>> slack-reallocation methods have come up in this discussion (sorry, I'm
>> really
>> pressed for time and didn't look), but we didn't get into that in our
>> paper.
> So, if I understand well (sorry, I am just trying to make a short 
> summary to check if we are aligned) your analysis is similar to the 
> one presented in the papers I mentioned earlier in this thread 
> (different stochastic modelling, but similar approach): you analyse a 
> reservation in isolation and you provide some stochastic tardiness 
> guarantees based on an (e_i, p_i) service model.... Right?
Sorry, I don't have time right now to check these papers, but what you 
are saying sounds correct.

>
> If my understanding is correct (please, correct me if I am wrong), 
> your analysis can be applied even with the current version of Dario's 
> patch (I mean: no modifications to the patch are needed for removing 
> assumptions about WCET knowledge... Your paper uses a sporadic server 
> for the reservation mechanism, but I think a CBS can work too...).

This sounds correct a well.  We assume that if a job of a task overruns 
its current budget allocation (which will likely happen, provisioning 
reservations on the average case), then the remainder of that job will 
be executed using future allocations for the same task.  The analysis 
doesn't (I think) depend too much on the exact way reservations are 
supported.

-Jim


