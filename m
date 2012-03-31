Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab2CaANc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:13:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13199 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab2CaAN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:13:29 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wMWVvwg0qUAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=1IgKvS_jCbM8X3mIm0AA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1333152806.23924.196.camel@gandalf.stny.rr.com>
Subject: Re: syscall_regfunc() && TIF_SYSCALL_TRACEPOINT
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2012 20:13:26 -0400
In-Reply-To: <20120330201550.GA16628@redhat.com>
References: <20120330183104.GA12927@redhat.com>
	 <1333134131.23924.191.camel@gandalf.stny.rr.com>
	 <20120330201550.GA16628@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 22:15 +0200, Oleg Nesterov wrote:

> > A lot of places test ->mm for kernel threads.
> 
> And this is wrong, use_mm() can set ->mm != NULL. This is the common
> mistake.
> 
> > Just search for ->mm in
> > kernel/sched/core.c
> 
> Probably normalize_rt_tasks() and __sched_setscheduler() should be fixed.

Heh, the __sched_setscheduler() usage is from me. But I'm not sure we
had an alternative back in 2005.


> But I don't really understand why do you think that "clear" is more
> important.

They are both important. But as I tend to consider performance when
tracing is off as critical, I'm more concerned about that. But both must
be fixed, because not reporting traces can confuse a developer.



>  Sure, the wrong TIF_SYSCALL_TRACEPOINT triggers the slow
> path unnecessary, but this is more or less harmless. But if we do
> not set the task obviously won't report trace_sys*, this looks like
> a bug even if nothing bad can happen.

Agreed, both are a bug and both should be fixed.

Thanks,

-- Steve


