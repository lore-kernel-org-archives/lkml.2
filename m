Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2FOLde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:33:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2FOLdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:33:32 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=3XTHfUCqClUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=6sL5daoBBzrDOCtk-r8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339760011.13377.338.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 05/13 v2] ftrace/x86: Add separate function to save
 regs
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Fri, 15 Jun 2012 07:33:31 -0400
In-Reply-To: <4FDAEF18.6040703@hitachi.com>
References: <20120612224327.426900129@goodmis.org>
	 <20120612225425.218922417@goodmis.org> <4FDAEF18.6040703@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 17:15 +0900, Masami Hiramatsu wrote:

> > It is OK for an arch to pass NULL regs. All function trace users that
> > require regs passing must add the flag FTRACE_OPS_FL_SAVE_REGS when
> > registering the ftrace_ops and either check if regs is not NULL or
> > check if ARCH_SUPPORTS_FTRACE_SAVE_REGS. If the arch supports passing
> > regs it will set this macro and pass regs for ops that request them.
> > All other archs will just pass NULL.
> 
> Hmm, so would you mean that user is responsible for checking
> whether the arch supports save_regs or not?
> I would rather like ftrace to check it as my patch has done.
> I think ARCH_SUPPORTS_FTRACE_SAVE_REGS macro checking in all
> handler code is something like odd...

I was thinking of routines that may or may not use regs. Actually, I was
thinking about perf in general, that could use regs if supported, or get
its own set.

But I agree that it may not be the best for those that must have regs.

Perhaps we could add another flag:

FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED

Where it wont error out if you have this set. But if you just pass in
FTRACE_OPS_FL_SAVE_REGS (as kprobes does) it will fail.

How's that sound?

-- Steve


