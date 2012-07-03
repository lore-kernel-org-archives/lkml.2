Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2GCL4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:56:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11769 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2GCL4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:56:04 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=odYAoRyd9-MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=KvpZUgZ_DSA11vBBjbgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341316560.21574.5.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 6/6] ftrace/x86: Add save_regs for i386 function calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 03 Jul 2012 07:56:00 -0400
In-Reply-To: <4FF282AA.1050109@hitachi.com>
References: <20120702200322.573660631@goodmis.org>
	 <20120702201822.052770797@goodmis.org> <4FF282AA.1050109@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 14:27 +0900, Masami Hiramatsu wrote:
> (2012/07/03 5:03), Steven Rostedt wrote:

> > +GLOBAL(ftrace_regs_call)
> > +	call ftrace_stub
> > +
> > +	addl $4,%esp		/* Skip pt_regs */
> 
> Hmm, you need to restoring flags here, because
> original flags is clobbered by KERNEL_CS.
> 
> 	movl 14*4+4(%esp), %edx
> 	movl %edx, 13*4+4(%esp)

Ah, you're right. I'll update it. I need to make changes anyway, because
I found that if I have a kprobe using ftrace and enable function graph
tracer, the machine triple faults. I'm working on fixing that now.

Thanks!

-- Steve


