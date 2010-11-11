Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0KKMTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:19:47 -0500
Received: from canuck.infradead.org ([134.117.69.58]:51061 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab0KKMTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:19:45 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Peter Zijlstra <peterz@infradead.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
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
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <4CDB2BBD.6040408@sssup.it>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop>
	 <1289417173.2084.43.camel@laptop>  <4CDB2BBD.6040408@sssup.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 13:19:26 +0100
Message-ID: <1289477966.2084.70.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 00:33 +0100, Tommaso Cucinotta wrote:
> Il 10/11/2010 20:26, Peter Zijlstra ha scritto:
> >> I would suggest we add at least one more field so we can implement the
> >> stochastic model from UNC, sched_runtime_dev or sched_runtime_var or
> >> somesuch.
> > Oh, and their model has something akin to: sched_runtime_max, these
> > Gaussian bell curves go to inf. which is kinda bad for trying to compute
> > bounds.
> If I understand well the paper you're referring to, the actual admission 
> test would require also to specify a maximum acceptable expected 
> tardiness, and/or proper quantiles of the tardiness distribution, and 
> also it would require to solve a linear programming optimization problem 
> in order to check those bounds. You don't want this stuff to go into the 
> kernel, do you ?

I'm not sure it does, the admission test only uses the average runtime
and uses the fact that it averages out to this (or less) to ensure
tardiness is bounded.

So the stochastic model allows for temporal overload situations but
because of the average nature next jobs must make up for the overrun of
a previous job, negating the overload.

So on average the system isn't overloaded.

The only reason we need the max runtime limit is because avg+stdev dont
actually place a bound on anything, like said the Gaussian bell curve
goes all the way out to infinity.


