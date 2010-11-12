Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0KLRwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:52:02 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40120 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab0KLRwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:52:01 -0500
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <4CDD7C65.9090400@unitn.it>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>
	 <1289576177.6525.509.camel@Palantir> <1289577841.2084.302.camel@laptop>
	 <4CDD7C65.9090400@unitn.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 18:51:35 +0100
Message-ID: <1289584295.2084.343.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 18:41 +0100, Luca Abeni wrote:
> > The problem the stochastic execution time model tries to address is the
> > WCET computation mess, WCET computation is hard and often overly
> > pessimistic, resulting in under-utilized systems.
> [...]
> BTW, sorry for the shameless plug, but even with the current 
> SCHED_DEADLINE you are not forced to dimension the runtime using the 
> WCET. 

Yes you are, it pushes the deadline back on overrun. The idea it to
maintain the deadline despite overrunning your budget (up to a point).

The paper we're all talking about is:

A. Mills and J. Anderson, " A Stochastic Framework for Multiprocessor
Soft Real-Time Scheduling", Proceedings of the 16th IEEE Real-Time and
Embedded Technology and Applications Symposium, pp. 311-320, April 2010.
http://www.cs.unc.edu/~anderson/papers/rtas10brevised.pdf

And I see they've got a new stochastic paper out:

A. Mills and J. Anderson, " Scheduling Stochastically-Executing Soft
Real-Time Tasks: A Multiprocessor Approach Without Worst-Case Execution
Times", in submission. 
http://www.cs.unc.edu/~anderson/papers/rtas11b.pdf


