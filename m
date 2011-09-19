Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1ISVtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:49:51 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:22993 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756409Ab1ISVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:49:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: agYujqoVM1nzAxykN3tVsYMhLbSrKUZTi7N.VaSZdbZ7aHB
 BDsVTIVnkn003wqpELlHbElXtNTDSqcFrGITVDguZfUWtrDEk_6idduFQRBv
 Mc_AaAnTt9uS2piqJwFAUih7S3bKW0IOcTrH83jzJeMI0aBBK0dhMFAM8gLh
 CTKw3bsPvKkOIadVejrhH1RcE5udZxWHeDSqOj0.Hr37gZ5b5pUiM9Wt9WOE
 JtjkeIbBJ4D46dCdK1PiiSB_tlJZoE9XNdFmniFRsVL7G4qHVYBBEscfgnAo
 D9CaaIQy2l_uWqw.7y5JCTPnattBBXeLhBRqPhdTM.qDcqEbEqZ2Q8Vy46E7
 tta7qX_i.4IQLH49yfVj46efuN1r3CcZRAAkLABSxSPcZTdGxnXQsDJWArqI
 3zSHR5_.m1iJWsvVdkbxh2Ig-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Sep 2011 16:49:47 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <20110919212040.745370781@goodmis.org>
Message-ID: <alpine.DEB.2.00.1109191644190.19059@router.home>
References: <20110919212040.745370781@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Steven Rostedt wrote:

> I just found out that the this_cpu_*() functions do not perform the
> test to see if the usage is in atomic or not. Thus, the blind
> conversion of the per_cpu(*, smp_processor_id()) and the get_cpu_var()
> code to this_cpu_*() introduce the regression to detect the hard
> to find case where a per cpu variable is used in preempt code that
> migrates and causes bugs.

this_cpu_* function can be used either way. There is no point in checking
for atomic or not since the this_cpu_* implementations are required to
take care of disabling preemption. Those operations are generally safe to
use regardless of the context.

It can be replaced by __this_cpu_* only when we know that the context
prevents races through disabling preemption.
