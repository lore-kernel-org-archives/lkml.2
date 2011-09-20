Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1ITQFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:05:20 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:49061 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751056Ab1ITQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:05:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ftxZiqsVM1mepOjPAQ7hkqiSbpdgkvYG0hM6F5OCtBDFV8Y
 VJ8IOjDoyJ5aT07dpKVyktEcPdakrGa6l1JOcmsB2iUlxbSRNzkSpxGLFtKQ
 3lZradFIcRHX0mPm0p4WFc_g2KKIIYnYwThOnXGaeAt8bCqqjbyT3Gtsf3Cg
 zkvRgPef6tOFBWxoxJwzO.XASoKDoGUGeeAcUDCj2xu9UftLjLRIhEmV9ipU
 SMyqdRspkmhR4YxMq3VXvrgwT2MJ32j1AU8QBBwBT9Y_BIwIR7wix1JWzGA6
 jRH3SBd33iA5F_PRBlJ_ctyblB16USqKtm5AySxmQr4iMDmv0Z3zu0XoXKSx
 4lwkqgntrYh6ieIGMWUu9_ofvniV5FgGy.KYxx4md_qf8gsTZJooTDXI.Rde
 yHwGdGEA8888QHfEWZdhTncI-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 11:05:15 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <1316531252.13664.39.camel@twins>
Message-ID: <alpine.DEB.2.00.1109201102340.8056@router.home>
References: <20110919212040.745370781@goodmis.org>   <m2ehzcdkf2.fsf@firstfloor.org>  <1316488378.29966.35.camel@gandalf.stny.rr.com>  <alpine.LFD.2.02.1109200933310.2723@ionos>  <alpine.DEB.2.00.1109201000120.8056@router.home>
 <1316531252.13664.39.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Peter Zijlstra wrote:

> On Tue, 2011-09-20 at 10:03 -0500, Christoph Lameter wrote:
> >
> > Well yes the misunderstanding of per cpu operations was one reason why I
> > proposed the discussion on the subject of esoteric kernel synchronization.
> > I do not think that it was accepted.
>
> I don't think anybody here misunderstands it, we're just all very angry
> that its causing so much problems.

What problems? RT does not work with it? The memcg confusion?

> __this_cpu doesn't have preempt debug checks, and there's a lot of
> this_cpu usage that really should have been __this_cpu.

That only works if preemption is disabled when the this_cpu op is being
invoked.


