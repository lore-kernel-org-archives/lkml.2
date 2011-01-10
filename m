Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1AJPBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:01:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1AJPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:00:59 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=YGCV5_ce828A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=fpJaJQQJr7WXlpoWl_AA:9 a=bIylCc_IV3IOcoFCdjxovEd-wlIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:perf/urgent] tracing: Include module.h in define_trace.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <1294671171.26623.240.camel@gandalf.stny.rr.com>
References: <tip-3a9f987b3141f086de27832514aad9f50a53f754@git.kernel.org>
	 <1294667377.11896.3.camel@laptop>
	 <1294668888.26623.238.camel@gandalf.stny.rr.com>
	 <1294670334.11896.8.camel@laptop>
	 <1294671171.26623.240.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 10 Jan 2011 10:00:57 -0500
Message-ID: <1294671657.26623.242.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 09:52 -0500, Steven Rostedt wrote:

> >   LD      vmlinux.o
> > kernel/built-in.o:(__tracepoints+0xac0): multiple definition of `__tracepoint_module_request'
> > arch/x86/built-in.o:(__tracepoints+0x100): first defined here
> > kernel/built-in.o:(__tracepoints+0xa40): multiple definition of `__tracepoint_module_get'
> > arch/x86/built-in.o:(__tracepoints+0x80): first defined here
> > kernel/built-in.o:(__tracepoints+0x9c0): multiple definition of `__tracepoint_module_load'
> > arch/x86/built-in.o:(__tracepoints+0x0): first defined here
> > kernel/built-in.o:(__tracepoints+0xa80): multiple definition of `__tracepoint_module_put'
> > arch/x86/built-in.o:(__tracepoints+0xc0): first defined here
> > kernel/built-in.o:(__tracepoints+0xa00): multiple definition of `__tracepoint_module_free'
> > arch/x86/built-in.o:(__tracepoints+0x40): first defined here
> 
> Hmm, OK, I'm able to reproduce it when I add:

Correction, I only reproduced this because I'm an idiot ;-)

> 
> #define CREATE_TRACE_POINTS
> #include <trace/events/syscalls.h>
> #undef CREATE_TRACE_POINTS
> 
> as the first thing in ptrace.c. I'll investigate this further.

I added this, but forgot to remove:

#define CREATE_TRACE_POINTS
#include <trace/events/syscalls.h>

that is at the bottom, causing the duplicate definitions.

Removing the second installation, it complies fine.

Thus, it works fine for me. :-/

-- Steve



