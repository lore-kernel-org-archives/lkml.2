Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0KKToG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:44:06 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52360 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0KKToE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:44:04 -0500
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
In-Reply-To: <1289503883.6525.107.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334050.8661.150.camel@Palantir>  <1289503054.2084.156.camel@laptop>
	 <1289503883.6525.107.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:43:55 +0100
Message-ID: <1289504635.2084.179.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 20:31 +0100, Raistlin wrote:
> On Thu, 2010-11-11 at 20:17 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-10-29 at 08:34 +0200, Raistlin wrote:
> > > Make it possible to specify a period (different or equal than
> > > deadline) for -deadline tasks.
> > > 
> > I would expect it to be:
> > 
> > runtime <= deadline <= period
> > 
> Well, apart from that really unhappy comment/changelog, it should be
> like that in the code, and if it's not, it is what I meant and I'll
> change to that as soon as I can! :-)
> 
> Since you spotted it... The biggest issue here is admission control
> test. Right now this is done against task's bandwidth, i.e.,
> sum_i(runtime_i/period_i)<=threshold, but it is unfortunately wrong...
> Or at least very, very loose, to the point of being almost useless! :-(

Right, I have some recollection on that.

> The more correct --in the sense that it at least yield a sufficient (not
> necessary!) condition-- thing to do would be
> sum_i(runtime_i/min{deadline_i,period_i})<=threshold.
> 
> So, what you think we should do? Can I go for this latter option?

I remember we visited this subject last time, but I seem to have
forgotten most details.

So sufficient (but not necessary) means its still a pessimistic approach
but better than the one currently employed, or does it mean its
optimistic and allows for unschedulable sets to be allowed in?

