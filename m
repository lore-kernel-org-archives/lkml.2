Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2GQDFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:05:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14751 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2GQDFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:05:05 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=XNQpylE1qVEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=rC1YjGRAAVr1ZOzKU2sA:9 a=PUjeQqilurYA:10 a=ixWRYfBGf40AuYSc:21 a=IhOYEygcIkKMk7j_:21 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342494302.24525.4.camel@gandalf.stny.rr.com>
Subject: Re: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386
 function calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Mon, 16 Jul 2012 23:05:02 -0400
In-Reply-To: <5004C917.1060909@hitachi.com>
References: <20120711195048.885039013@goodmis.org>
	  <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>
	 <1342205273.30075.19.camel@gandalf.stny.rr.com>
	 <5004C917.1060909@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 11:08 +0900, Masami Hiramatsu wrote:

> > I found that regs_get_register() doesn't honor this either. Thus,
> > kprobes in tracing gets this:
> > 
> >  # echo 'p:ftrace sys_read+4 s=%sp' > /debug/tracing/kprobe_events
> >  # echo 1 > /debug/tracing/events/kprobes/enable
> >  # cat trace
> >             sshd-1345  [000] d...   489.117168: ftrace: (sys_read+0x4/0x70) s=b7e96768
> >             sshd-1345  [000] d...   489.117191: ftrace: (sys_read+0x4/0x70) s=b7e96768
> >              cat-1447  [000] d...   489.117392: ftrace: (sys_read+0x4/0x70) s=5a7
> >              cat-1447  [001] d...   489.118023: ftrace: (sys_read+0x4/0x70) s=b77ad05f
> >             less-1448  [000] d...   489.118079: ftrace: (sys_read+0x4/0x70) s=b7762e06
> >             less-1448  [000] d...   489.118117: ftrace: (sys_read+0x4/0x70) s=b7764970
> > 
> 
> Yes, that is by design, since I made it so. :)
> Instead of %sp, kprobe tracer provides $stack special argument
> for stack address, because "sp" is not always means the stack
> address on every arch.

But is that useful? Wouldn't the actual stack pointer be more
informative?

-- Steve


