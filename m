Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0KLRpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:45:34 -0500
Received: from mail0.unitn.it ([193.205.206.51]:45502 "EHLO mail0.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab0KLRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:45:33 -0500
Message-ID: <4CDD7C65.9090400@unitn.it>
Date: Fri, 12 Nov 2010 18:41:57 +0100
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
References: <1288333128.8661.137.camel@Palantir>	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>	 <1289576177.6525.509.camel@Palantir> <1289577841.2084.302.camel@laptop>
In-Reply-To: <1289577841.2084.302.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/10 17:04, Peter Zijlstra wrote:
> On Fri, 2010-11-12 at 16:36 +0100, Raistlin wrote:
>> But at this point I can't avoid asking. That model aims at _pure_
>> hard real-time scheduling *without* resource reservation capabilities,
>> provided it deals with temporal overruns by means of a probabilistic
>> analysis, right?
>
>> From what I understood from it, its a soft real-time scheduling
> algorithm with resource reservation. It explicitly allows for deadline
> misses, but requires the tardiness of those misses to be bounded, ie.
> the UNC soft real-time definition.
>
> The problem the stochastic execution time model tries to address is the
> WCET computation mess, WCET computation is hard and often overly
> pessimistic, resulting in under-utilized systems.
[...]
BTW, sorry for the shameless plug, but even with the current 
SCHED_DEADLINE you are not forced to dimension the runtime using the 
WCET. You can use some stochastic analysis, providing probabilistic 
deadline guarantees. See (for example) "QoS Guarantee Using 
Probabilistic Deadlines"
http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.7683&rep=rep1&type=pdf
and "Stochastic analysis of a reservation based system"
http://www.computer.org/portal/web/csdl/doi?doc=doi/10.1109/IPDPS.2001.925049
(sorry, this is not easy to download... But I can provide a copy if you 
are interested).


			Luca
