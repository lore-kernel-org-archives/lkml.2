Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab2IFPyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:54:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab2IFPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:54:50 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=pZdUz1oXxZcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7I6Cu-NdG9YA:10 a=IMuEHB_S7bplftPntRgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346946887.1680.31.camel@gandalf.local.home>
Subject: Re: [PATCH] x86, 32-bit: Fix invalid stack address while in softirq
From: Steven Rostedt <rostedt@goodmis.org>
To: Robert Richter <robert.richter@amd.com>
Cc: wyang1 <Wei.Yang@windriver.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
Date: Thu, 06 Sep 2012 11:54:47 -0400
In-Reply-To: <20120906153647.GB8285@erda.amd.com>
References: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com>
	 <20120904102439.GS8285@erda.amd.com> <5047FCBD.9000205@windriver.com>
	 <20120906100434.GX8285@erda.amd.com>
	 <1346937282.1680.15.camel@gandalf.local.home>
	 <20120906150246.GZ8285@erda.amd.com>
	 <1346944482.1680.28.camel@gandalf.local.home>
	 <20120906153407.GA8285@erda.amd.com> <20120906153647.GB8285@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 17:36 +0200, Robert Richter wrote:

> I meant:
> 
> unsigned long kernel_stack_pointer(struct pt_regs *regs)
> {
> 	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
> 	unsigned long sp = (unsigned long)&regs->sp;
> 	struct thread_info *tinfo;
> 
> 	if (context == (sp & ~(THREAD_SIZE - 1)))
> 		return sp;
> 	
> 	tinfo = (struct thread_info *)context;
> 	if (tinfo->previous_esp)
> 		return tinfo->previous_esp;
> 
> 	return (unsigned long)regs;
> }
> 
> -Robert
> 
> > 
> > Maybe this is even better.
> > 
> >

Yeah, this is probably the safest.

Thanks,

-- Steve


