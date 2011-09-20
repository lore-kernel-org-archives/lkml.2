Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1ITPDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:03:24 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:29078 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751726Ab1ITPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:03:23 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3XtGAx8VM1moBN.u_3qsnSmhd7bvLhxWmCfFwL8FIpAa2fW
 IhsPXyZa9FnKXwdcSm.jbpaRxCQ80nyzahGEFiJxHXYRVFkM2pURMNGsA14M
 Oq7Soke1hh1ten_Qgg5ZzR6U.gOm8icEjA.NR5a2TNb_rCJnN69mEzWwZvoM
 WfRsJfrZ4RHvC.jQ5Eixx6jXyjzWTW1sqsgK2ikET_XlJSVatA1hNpTZGWfK
 bjOlUH8JQ_dTtdg2wcdtHtelrLWV2xNbFI9YxkD3l1dWfLAyn6VeW_.FPiqF
 QXgm4Wb7_OkjwoKbo2K54qK1OUnLhFJutOzRvhKycgyyN2zm8Na1fkxE8LMa
 ULwiA8nxISdJv5dy6agOKhTxB5m.8T7wjCiv1JdIoabbd5bXkmlk-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 10:03:18 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <alpine.LFD.2.02.1109200933310.2723@ionos>
Message-ID: <alpine.DEB.2.00.1109201000120.8056@router.home>
References: <20110919212040.745370781@goodmis.org>  <m2ehzcdkf2.fsf@firstfloor.org> <1316488378.29966.35.camel@gandalf.stny.rr.com> <alpine.LFD.2.02.1109200933310.2723@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Thomas Gleixner wrote:

> On Mon, 19 Sep 2011, Steven Rostedt wrote:
> > On Mon, 2011-09-19 at 19:20 -0700, Andi Kleen wrote:
> > > Steven Rostedt <rostedt@goodmis.org> writes:
> > >
> > > > I just found out that the this_cpu_*() functions do not perform the
> > > > test to see if the usage is in atomic or not. Thus, the blind
> > > > conversion of the per_cpu(*, smp_processor_id()) and the get_cpu_var()
> > > > code to this_cpu_*() introduce the regression to detect the hard
> > > > to find case where a per cpu variable is used in preempt code that
> > > > migrates and causes bugs.
>
> Just for the record. I added some this_cpu_* debug checks to my
> filesystem eating 2.6.38-rt and guess what: They trigger right away in
> the FS code and without digging deeper I'm 100% sure, that this is the
> root cause of the problems I was hunting for weeks. Thanks for wasting
> my time and racking my nerves.

this_cpu_xx is safe to use in preemptable contexts. So what does this have
to do with your FS problems?

> Can we please put that on the KS agenda? This definitely needs to be
> addressed urgently.

Well yes the misunderstanding of per cpu operations was one reason why I
proposed the discussion on the subject of esoteric kernel synchronization.
I do not think that it was accepted.

