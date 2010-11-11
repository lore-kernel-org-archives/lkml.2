Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0KKNc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:32:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:34337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab0KKNc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:32:26 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
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
In-Reply-To: <1289427476.13577.285.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop>
	 <1289427476.13577.285.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 14:32:13 +0100
Message-ID: <1289482333.2084.102.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 23:17 +0100, Raistlin wrote:
> On Wed, 2010-11-10 at 18:28 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-10-29 at 08:27 +0200, Raistlin wrote:
> > > +struct sched_param_ex {
> > > +       int sched_priority;
> > > +       struct timespec sched_runtime;
> > > +       struct timespec sched_deadline;
> > > +       struct timespec sched_period;
> > > +       unsigned int sched_flags;
> > > +
> > > +       struct timespec curr_runtime;
> > > +       struct timespec used_runtime;
> > > +       struct timespec curr_deadline;
> > > +}; 
> > 
> > It would be better for alignment reasons to move the sched_flags field
> > next to the sched_priority field.
> > 
> Makes sense, thanks. :-)
> 
> > I would suggest we add at least one more field so we can implement the
> > stochastic model from UNC, sched_runtime_dev or sched_runtime_var or
> > somesuch.
> > 
> Ok, no problem with that too.
> 
> BTW, as Dhaval was suggesting, are (after those changes) fine with this
> new sched_param? Do we need some further mechanism to grant its
> extendability?
> Padding?
> Versioning?
> void *data field?
> Whatever?
> 
> :-O
> 
> I'd like very much to have some discussion here, if you think it is
> needed, in hope of avoiding future ABI issues as much as possible! :-P

Right, so you mentioned doing s/_ex/2/ on all this stuff, which brings
it more in line with that other syscalls have done.

The last three parameters look to be output only as I've not yet found
code that reads it, and __getparam_dl() doesn't even appear to set
used_runtime.

One thing you can do is add some padding, versioning and void*
extentions are doable for the setparam() path, but getparam() is going
to be mighty interesting.


