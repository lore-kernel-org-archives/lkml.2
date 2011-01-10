Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1AJOwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:52:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1AJOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:52:53 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=YGCV5_ce828A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=5XapSVtpIriz-Wek_R0A:9 a=XHYarGKZdO06Y-IrXmo2ZySF0lMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:perf/urgent] tracing: Include module.h in define_trace.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <1294670334.11896.8.camel@laptop>
References: <tip-3a9f987b3141f086de27832514aad9f50a53f754@git.kernel.org>
	 <1294667377.11896.3.camel@laptop>
	 <1294668888.26623.238.camel@gandalf.stny.rr.com>
	 <1294670334.11896.8.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 10 Jan 2011 09:52:51 -0500
Message-ID: <1294671171.26623.240.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 15:38 +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-10 at 09:14 -0500, Steven Rostedt wrote:
> > > @@ -21,16 +21,6 @@
> > >  #undef CREATE_TRACE_POINTS
> > 
> > But here we undefine CREATE_TRACE_POINTS, why would this cause a problem
> > in module.h?
> 
> I'm not sure what's happening, all I know is that without this change I
> get:
> 
>   LD      vmlinux.o
> kernel/built-in.o:(__tracepoints+0xac0): multiple definition of `__tracepoint_module_request'
> arch/x86/built-in.o:(__tracepoints+0x100): first defined here
> kernel/built-in.o:(__tracepoints+0xa40): multiple definition of `__tracepoint_module_get'
> arch/x86/built-in.o:(__tracepoints+0x80): first defined here
> kernel/built-in.o:(__tracepoints+0x9c0): multiple definition of `__tracepoint_module_load'
> arch/x86/built-in.o:(__tracepoints+0x0): first defined here
> kernel/built-in.o:(__tracepoints+0xa80): multiple definition of `__tracepoint_module_put'
> arch/x86/built-in.o:(__tracepoints+0xc0): first defined here
> kernel/built-in.o:(__tracepoints+0xa00): multiple definition of `__tracepoint_module_free'
> arch/x86/built-in.o:(__tracepoints+0x40): first defined here

Hmm, OK, I'm able to reproduce it when I add:

#define CREATE_TRACE_POINTS
#include <trace/events/syscalls.h>
#undef CREATE_TRACE_POINTS

as the first thing in ptrace.c. I'll investigate this further.

Thanks!

-- Steve


