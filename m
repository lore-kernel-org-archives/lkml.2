Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0KKWPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:15:42 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60889 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0KKWPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:15:41 -0500
Subject: Re: [RFC][PATCH 20/22] sched: drafted deadline inheritance logic
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
In-Reply-To: <1288334618.8661.162.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334618.8661.162.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 23:15:15 +0100
Message-ID: <1289513715.2084.201.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:43 +0200, Raistlin wrote:
> Some method to deal with rt-mutexes and make sched_dl interact with
> the current PI-coded is needed, raising all but trivial issues, that
> needs (according to us) to be solved with some restructuring of
> the pi-code (i.e., going toward a proxy execution-ish implementation).
> 
> This is under development, in the meanwhile, as a temporary solution,
> what this commits does is:
>  - ensure a pi-lock owner with waiters is never throttled down. Instead,
>    when it runs out of runtime, it immediately gets replenished and it's
>    deadline is postponed (as in SF_BWRECL_DL reclaiming policy);
>  - the scheduling parameters (relative deadline and default runtime)
>    used for that replenishments --during the whole period it holds the
>    pi-lock-- are the ones of the waiting task with earliest deadline.
> 
> Acting this way, we provide some kind of boosting to the lock-owner,
> still by using the existing (actually, slightly modified by the previous
> commit) pi-architecture.

Right, so this is the trivial priority ceiling protocol extended to
bandwidth inheritance and we basically let the owner overrun its runtime
to release the shared resource.

Didn't look at it too closely, but yeah, that is a sensible first
approximation band-aid to keep stuff working.

