Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423047Ab2KNQ5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:57:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2KNQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:57:54 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=64KZV6gX4dAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5Rm-iVo867QA:10 a=Fi4gsGoIr_M_-jfaXOIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352912273.18025.67.camel@gandalf.local.home>
Subject: Re: [PATCH 1/4] vtime: Remove the underscore prefix invasion
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 14 Nov 2012 11:57:53 -0500
In-Reply-To: <CAFTL4hz11T2oy5ohBE16snuzq1cmUn3M_6Q57qzrjH=PmiYiZw@mail.gmail.com>
References: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
	 <1352910413-10759-2-git-send-email-fweisbec@gmail.com>
	 <1352911221.18025.66.camel@gandalf.local.home>
	 <CAFTL4hz11T2oy5ohBE16snuzq1cmUn3M_6Q57qzrjH=PmiYiZw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 17:48 +0100, Frederic Weisbecker wrote:
> 2012/11/14 Steven Rostedt <rostedt@goodmis.org>:
> > On Wed, 2012-11-14 at 17:26 +0100, Frederic Weisbecker wrote:
> >> Prepending irq-unsafe vtime APIs with underscores was actually
> >> a bad idea as the result is a big mess in the API namespace that
> >> is even waiting to be further extended. Also these helpers
> >> are always called from irq safe callers except kvm. Just
> >> provide a vtime_account_system_irqsafe() for this specific
> >> case so that we can remove the underscore prefix on other
> >> vtime functions.
> >>
> >
> >
> >> -void __vtime_account_system(struct task_struct *tsk)
> >> +void vtime_account_system(struct task_struct *tsk)
> >>  {
> >>       cputime_t delta = vtime_delta(tsk);
> >
> > Should we add a WARN_ON(!irqs_disabled()) check here?
> 
> Why not, I'll add one in vtime_delta().

Probably make it a WARN_ON_ONCE() no need to spam the console.

-- Steve


