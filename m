Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab0KLNpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:45:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:52164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0KLNpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:45:45 -0500
Subject: Re: [RFC][PATCH 09/22] sched: add period support for -deadline
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <1289568827.6525.411.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334050.8661.150.camel@Palantir>  <1289503054.2084.156.camel@laptop>
	 <1289503883.6525.107.camel@Palantir>  <1289504635.2084.179.camel@laptop>
	 <1289568827.6525.411.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 14:45:33 +0100
Message-ID: <1289569533.2084.258.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 14:33 +0100, Raistlin wrote:
> On Thu, 2010-11-11 at 20:43 +0100, Peter Zijlstra wrote:
> > > Since you spotted it... The biggest issue here is admission control
> > > test. Right now this is done against task's bandwidth, i.e.,
> > > sum_i(runtime_i/period_i)<=threshold, but it is unfortunately wrong...
> > > Or at least very, very loose, to the point of being almost useless! :-(
> > 
> > Right, I have some recollection on that.
> > 
> :-)
> 
> > So sufficient (but not necessary) means its still a pessimistic approach
> > but better than the one currently employed, or does it mean its
> > optimistic and allows for unschedulable sets to be allowed in?
> > 
> Tommaso already gave the best possible explanation of this! :-P
> 
> So, trying to recap:
>  - using runtime/min(deadline,period) _does_ guarantee schedulability,
>    but also rejects schedulable situations in UP/partitioning. Quite
>    sure it _does_not_ guarantee schedulability in SMP/global, but
>    *should* enable bounded tardiness;
>  - using runtime/period _does_not_ guarantee schedulability nor in
>    UP/partitioning neither in SMP/global, but *should* enable bounded
>    tardiness for _both_.

> Thus, all this being said, what do you want me to do? :-D

runtime/min(deadline,period) sounds fine, as its more useful than
runtime/period.
