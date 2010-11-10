Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0KJT0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:26:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57264 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab0KJT0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:26:17 -0500
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
In-Reply-To: <1289410114.2084.23.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 20:26:13 +0100
Message-ID: <1289417173.2084.43.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 18:28 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:27 +0200, Raistlin wrote:
> > +struct sched_param_ex {
> > +       int sched_priority;
> > +       struct timespec sched_runtime;
> > +       struct timespec sched_deadline;
> > +       struct timespec sched_period;
> > +       unsigned int sched_flags;
> > +
> > +       struct timespec curr_runtime;
> > +       struct timespec used_runtime;
> > +       struct timespec curr_deadline;
> > +}; 
> 
> It would be better for alignment reasons to move the sched_flags field
> next to the sched_priority field.
> 
> I would suggest we add at least one more field so we can implement the
> stochastic model from UNC, sched_runtime_dev or sched_runtime_var or
> somesuch.

Oh, and their model has something akin to: sched_runtime_max, these
Gaussian bell curves go to inf. which is kinda bad for trying to compute
bounds.

 
