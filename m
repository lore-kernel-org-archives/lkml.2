Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2FOL3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:29:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14567 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab2FOL3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:29:48 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=BSkKP4v81lgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=cU4sW68RIQnF9wBd7OUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339759786.13377.334.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 06/13 v2] ftrace/x86: Add save_regs for i386
 function calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Fri, 15 Jun 2012 07:29:46 -0400
In-Reply-To: <4FDAD044.7020706@hitachi.com>
References: <20120612224327.426900129@goodmis.org>
	 <20120612225425.673392850@goodmis.org> <4FDAD044.7020706@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 15:03 +0900, Masami Hiramatsu wrote:
> (2012/06/13 7:43), Steven Rostedt wrote:

> > +GLOBAL(ftrace_regs_call)
> > +	call ftrace_stub
> > +
> > +	addl $4,%esp		/* Skip pt_regs */
> > +	popl %eax
> > +	movl %eax, 14*4(%esp)	/* Restore return address */
> > +	popl %ebx
> > +	popl %ecx
> > +	popl %edx
> > +	popl %esi
> > +	popl %edi
> > +	popl %ebp
> > +	popl %eax
> > +	popl %ds
> > +	popl %es
> > +	popl %fs
> > +	popl %gs
> > +	addl $8, %esp
> > +ftrace_exit:
> > +	addl $4, %esp		/* Skip eflags */
> 
> Hmm, why don't you recover eflags, as x86-64 has done?
> IMHO, it should be recovered if ftrace-based kprobe is
> a transparent acceleration.

As I copied this mostly from your patch I probably was thinking that it
saved it already ;-)

That is, we originally debated the usefulness of restoring eflags at the
start of the function call, as function calls give no guarantees to
them. I modified this patch to not restore flags. But later, I agreed
that I would keep kprobes the way it was, even though flags are pretty
meaningless here (unless you are going to have the kprobe modify the
enabling of interrupts), and decided to add back the flags. I simply
forgot to restore back to your original patch.

Will fix,

Thanks,

-- Steve




