Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1ITQJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:09:01 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:27656 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751231Ab1ITQJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:09:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Ekfn884VM1m5ADPjx4H2yR1bClw96wcmCs8xQ_50no5xTuf
 ve0CW2QFLPnC95rBWLjyLQowLgwaQRzoM.8Rc1zNw0uRNbv7_2cf9Tsp4txf
 a0O_l4lXtxs.K7XC_bHh.SHgbQlhnrs0za9nnEm8e6waa7IfeSM302HSzc.a
 GygUrFf43_P.xL_bB4VzLbiBrr7Dpu7T.xM.lbPjuOxMEy7op5Cvv.MRuwbB
 JemG5QTdCHFVl_hdD2QbUKOF.ImqNOaLgqbr8ZWBogeGfktSSD3T75Jf0Z20
 VBT273pjk1gO9DLoh_OUGb0TL04Zq.fUvHiQ4tioHtFBGS3W9Avb.NOJSKlY
 7.z.kDvfnDvlW674LDnlCLf7vi1fHO7qlTngzDUzRfWChlzUhvWec3vicHZ5
 pj1exx5QydlmsXu8Qh1bbJf8-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 11:08:56 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <1316531987.29966.65.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109201108080.8056@router.home>
References: <20110919212040.745370781@goodmis.org>  <alpine.DEB.2.00.1109191644190.19059@router.home>  <1316487977.29966.32.camel@gandalf.stny.rr.com>  <27409.1316522696@turing-police.cc.vt.edu>  <alpine.DEB.2.00.1109200955190.8056@router.home>
 <1316531987.29966.65.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Steven Rostedt wrote:

> On Tue, 2011-09-20 at 09:57 -0500, Christoph Lameter wrote:
>
> > this_cpu_xx functions are made for those locations that have
> > preemption enabled. If you can use those function (classic case is a
> > per cpu counter increment in the network subsystem) then you can avoid
> > preempt disable/enable or get_cpu/put_cpu.
>
> If the variables are used for a very short time, then the latencies
> introduced by a simple:
>
> 	var = get_cpu_var(my_var);
> 	if (var)
> 		do_something_quick();
> 	put_cpu_var(my_var);
>
> Otherwise if that do_something_quick(); migrates, it may be doing
> something it shouldn't be doing!

That is obviously a use case in which this_cpu_xx ops could not be used
since we must stay on the same cpu. I think there is still a lot of
confusion on your part. The example here shows it.

