Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab0KJXdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:33:23 -0500
Received: from ms01.sssup.it ([193.205.80.99]:49870 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757268Ab0KJXdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:33:21 -0500
X-Greylist: delayed 2173 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 18:33:21 EST
Message-ID: <4CDB2BBD.6040408@sssup.it>
Date: Thu, 11 Nov 2010 00:33:17 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
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
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
References: <1288333128.8661.137.camel@Palantir>	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop> <1289417173.2084.43.camel@laptop>
In-Reply-To: <1289417173.2084.43.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/11/2010 20:26, Peter Zijlstra ha scritto:
>> I would suggest we add at least one more field so we can implement the
>> stochastic model from UNC, sched_runtime_dev or sched_runtime_var or
>> somesuch.
> Oh, and their model has something akin to: sched_runtime_max, these
> Gaussian bell curves go to inf. which is kinda bad for trying to compute
> bounds.
If I understand well the paper you're referring to, the actual admission 
test would require also to specify a maximum acceptable expected 
tardiness, and/or proper quantiles of the tardiness distribution, and 
also it would require to solve a linear programming optimization problem 
in order to check those bounds. You don't want this stuff to go into the 
kernel, do you ?

There are plenty of complex schedulability tests for complex (and also 
distributed) RT applications modeled in a more or less complex way, 
scheduled under a variety of scheduling policies, with models including 
maximum and stochastic blocking times, task dependencies, offsets, and I 
don't know whatever else. These tests may be part of a user-space 
component. I would recommend to keep at the kernel level only a bare 
minimal set of functionality.

Deadlines different from periods are already a first complexity that I'm 
not sure we want to have in the interface. The easiest thing you can do 
there is to consider simply the minimum among the relative deadline and 
the period, but that would be equivalent to having only one parameter. 
More importantly, realizing complex admission control tests raises the 
issue of how to represent the "availability of RT CPU power" (as needed 
by "higher-level" logic/middleware). As far as we keep simple 
utilization-based admission tests (which might optionally be disabled), 
we still have some chance of representing such quantity.

Apologies for my 2 poor cents. I hope to see here a discussion (and I'll 
try to shut-up as much as possible :-) ).

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

