Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2GEUhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:37:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2GEUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:37:23 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=t8C3CB5ssRAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=zf-6Nngh-FGt2bPA_Q8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341520640.21574.19.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 5/6] ftrace/x86: Add separate function to save regs
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 05 Jul 2012 16:37:20 -0400
In-Reply-To: <1341334466.32545.140661097365717.3B7276E0@webmail.messagingengine.com>
References: <20120702200322.573660631@goodmis.org>
	 <20120702201821.510485400@goodmis.org>
	 <1341334466.32545.140661097365717.3B7276E0@webmail.messagingengine.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 18:54 +0200, Alexander van Heukelum wrote:
> On Mon, Jul 2, 2012, at 16:03, Steven Rostedt wrote:
> > Email had 1 attachment:
> > + 0005-ftrace-x86-Add-separate-function-to-save-regs.patch
> >   23k (text/plain)
> 
> Hi Steven,
> 
> One thing that caught my eye...
> 
> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > index e3e17a0..acd4963 100644
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -1109,6 +1109,7 @@ ENTRY(ftrace_caller)
> >  	pushl %eax
> >  	pushl %ecx
> >  	pushl %edx
> > +	pushl $0	/* Pass NULL as regs pointer */
> >  	movl 0xc(%esp), %eax
> 
> This should now be changed to "0x10(%esp)", right?

Yeah, I think you're right. Actually, I think I originally had it as:

	movl 0xc(%esp), %eax
+	pushl $0

But after a few other changes, it went to this. I haven't finished
testing against x86_64, and haven't started the i386 tests. I'm sure
this would have blown up then ;-)

Thanks,

-- Steve


> 
> Greetings,
>     Alexander
> 
> >  	movl 0x4(%ebp), %edx
> >  	leal function_trace_op, %ecx
> > @@ -1118,6 +1119,7 @@ ENTRY(ftrace_caller)
> >  ftrace_call:
> >  	call ftrace_stub
> >  
> > +	addl $4,%esp	/* skip NULL pointer */
> >  	popl %edx
> >  	popl %ecx
> >  	popl %eax


