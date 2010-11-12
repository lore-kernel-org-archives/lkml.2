Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab0KLQiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:38:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54455 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab0KLQit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:38:49 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=1jCsSUyidw0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0rWAtvBLjbSQOwlOlEoA:9 a=5t5IzcsV2UmJNIp4vX8A:7 a=5PlVO_mk6hOQFWizjyQU9CwFr6UA:4 a=PUjeQqilurYA:10 a=WefTbTLNXM0mvSy6:21 a=AU3MESDVpxDz2evq:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <1288333622.8661.141.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 11:38:44 -0500
Message-ID: <1289579924.12418.404.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:27 +0200, Raistlin wrote:

> +/*
> + * Extended scheduling parameters data structure.
> + *
> + * This is needed because the original struct sched_param can not be
> + * altered without introducing ABI issues with legacy applications
> + * (e.g., in sched_getparam()).
> + *
> + * However, the possibility of specifying more than just a priority for
> + * the tasks may be useful for a wide variety of application fields, e.g.,
> + * multimedia, streaming, automation and control, and many others.
> + *
> + * This variant (sched_param_ex) is meant at describing a so-called
> + * sporadic time-constrained task. In such model a task is specified by:
> + *  - the activation period or minimum instance inter-arrival time;
> + *  - the maximum (or average, depending on the actual scheduling
> + *    discipline) computation time of all instances, a.k.a. runtime;
> + *  - the deadline (relative to the actual activation time) of each
> + *    instance.
> + * Very briefly, a periodic (sporadic) task asks for the execution of
> + * some specific computation --which is typically called an instance--
> + * (at most) every period. Moreover, each instance typically lasts no more
> + * than the runtime and must be completed by time instant t equal to
> + * the instance activation time + the deadline.
> + *
> + * This is reflected by the actual fields of the sched_param_ex structure:
> + *
> + *  @sched_priority     task's priority (might still be useful)
> + *  @sched_deadline     representative of the task's deadline
> + *  @sched_runtime      representative of the task's runtime
> + *  @sched_period       representative of the task's period
> + *  @sched_flags        for customizing the scheduler behaviour
> + *
> + * There are other fields, which may be useful for implementing (in
> + * user-space) advanced scheduling behaviours, e.g., feedback scheduling:
> + *
> + *  @curr_runtime       task's currently available runtime
> + *  @used_runtime       task's totally used runtime
> + *  @curr_deadline      task's current absolute deadline
> + *
> + * Given this task model, there are a multiplicity of scheduling algorithms
> + * and policies, that can be used to ensure all the tasks will make their
> + * timing constraints.
> + */

A while ago I implemented an EDF scheduler for a client (before working
with Red Hat), and one thing they asked about was having a "soft group",
which was basically: This group is guaranteed X runtime in Y period, but
if the system is idle, let the group run, even if it has exhausted its X
runtime.

Is this supported?

-- Steve



