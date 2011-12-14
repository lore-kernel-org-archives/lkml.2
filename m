Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab1LNNlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:41:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1LNNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:41:02 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Jj81R3xejsoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=lAMJI3yp5VahQQjVQKQA:9 a=c-wvdQn9p5MHY7CpMjYA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323870059.23971.23.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 5/5 v2] x86: Allow NMIs to hit breakpoints in i386
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Date: Wed, 14 Dec 2011 08:40:59 -0500
In-Reply-To: <20111214133025.GA2882@Krystal>
References: <20111214025237.457632996@goodmis.org>
	 <20111214025253.519573056@goodmis.org> <20111214133025.GA2882@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 08:30 -0500, Mathieu Desnoyers wrote:

> Just to make sure I understand: if an NMI nests over do_nmi between
> nmi_postprocess() and the following iret (in which case the CPU is in
> state NMI_NOT_RUNNING), we will end up with two NMI handlers nested on
> the stack, right ? Given that there is no upper-bound on the nesting
> level of this situation (although nesting like this more than once is
> extremely unlikely), is this side-effect something we should care about
> in terms of stack space usage ?

At that point, there's very little on the stack to begin with. Just the
one irq frame, and saved regs, plus the stack frame of this function. If
we are hitting that many NMIs to cause a stack overflow, then I believe
there's more issues than the overflow itself. Say, a livelock of NMIs?

>  Also, is the stack dump OOPS handler
> aware of this stack layout that was until now impossible ?

Since NMIs on i386 doesn't change the stack when interrupting the
kernel, the OOPs handler never was aware of the NMI stack layout.

-- Steve



