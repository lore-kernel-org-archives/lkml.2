Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2GSSY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:24:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2GSSYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:24:54 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=XNQpylE1qVEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=3nbZYyFuAAAA:8 a=xaCACC6C0WTWiW9GShAA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342722292.12353.77.camel@gandalf.stny.rr.com>
Subject: Re: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386
 function calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Uros Bizjak <ubizjak@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Thu, 19 Jul 2012 14:24:52 -0400
In-Reply-To: <1342702344.12353.16.camel@gandalf.stny.rr.com>
References: <20120711195048.885039013@goodmis.org>
	 <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>
	 <1342205273.30075.19.camel@gandalf.stny.rr.com>
	 <1342627145.11900.7.camel@gandalf.stny.rr.com>
	 <50076ED9.3000100@hitachi.com>
	 <1342702344.12353.16.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 08:52 -0400, Steven Rostedt wrote:
> On Thu, 2012-07-19 at 11:20 +0900, Masami Hiramatsu wrote:
> > (2012/07/19 0:59), Steven Rostedt wrote:
> > > On Fri, 2012-07-13 at 14:47 -0400, Steven Rostedt wrote:
> > > 
> > > Masami, can you give your Reviewed-by tag for this version? Or is there
> > > something else needing to be fixed?
> > 
> > No, that is OK for me. I've just missed that...
> > 
> > Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > 
> > Thank you!
> > 
> 
> Thanks! Except I have one more version. Someone offlist gave me some
> ideas.
> 
> Here's the diff from the previous patch.
> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 46caa56..ca5a146 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1169,10 +1169,9 @@ ENTRY(ftrace_regs_caller)
>  	movl $__KERNEL_CS,13*4(%esp)
>  
>  	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
> -	movl 0x4(%ebp), %edx	/* Load parent ip (2cd parameter) */
> -	lea  (%esp), %ecx
> -	pushl %ecx		/* Save pt_regs as 4th parameter */
> +	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
>  	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
> +	pushl %esp		/* Save pt_regs as 4th parameter */
>  
>  GLOBAL(ftrace_regs_call)

I'm adding this as a separate patch under Uros's name.

I'll be posting the full series for pulling either tonight or tomorrow,
depending on how it handles all my stress tests.

-- Steve


