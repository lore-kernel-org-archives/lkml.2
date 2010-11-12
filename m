Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0KLTVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:21:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab0KLTVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:21:42 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=1jCsSUyidw0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ZZYEzd92nG1HpUK06gMA:9 a=BIMKooj8eda59Q6p68Seake9O6cA:4 a=PUjeQqilurYA:10 a=qRUA5rer598grKGD:21 a=hTKdJ93JH4BBwI3X:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Raistlin <raistlin@linux.it>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <4CDD7C6F.5000100@sssup.it>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>
	 <1289579924.12418.404.camel@gandalf.stny.rr.com>
	 <4CDD7C6F.5000100@sssup.it>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 14:21:38 -0500
Message-ID: <1289589698.12418.443.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 18:42 +0100, Tommaso Cucinotta wrote:
> Il 12/11/2010 17:38, Steven Rostedt ha scritto:
> > A while ago I implemented an EDF scheduler for a client (before working
> > with Red Hat), and one thing they asked about was having a "soft group",
> > which was basically: This group is guaranteed X runtime in Y period, but
> > if the system is idle, let the group run, even if it has exhausted its X
> > runtime.
> >
> > Is this supported?
> Actually, I know that Dario has an implementation of exactly this 
> feature (and it used to be implemented in our previous scheduler as 
> well, i.e., the old AQuoSA stuff):
> a per-task flag, when enabled, allows to put temporarily the task into 
> SCHED_OTHER when its budget is exhausted. Therefore, it will be allowed 
> to run for more than its budget but without breaking the temporal 
> isolation with the other SCHED_DEADLINE tasks. Furthermore, it won't 
> starve other SCHED_OTHER tasks, as it will compete with them for the CPU 
> during the budget-exhausted time windows.

Good to know, thanks!

-- Steve


