Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1AJOib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:38:31 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37009 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1AJOi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:38:28 -0500
Subject: Re: [tip:perf/urgent] tracing: Include module.h in define_trace.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <1294668888.26623.238.camel@gandalf.stny.rr.com>
References: <tip-3a9f987b3141f086de27832514aad9f50a53f754@git.kernel.org>
	 <1294667377.11896.3.camel@laptop>
	 <1294668888.26623.238.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 Jan 2011 15:38:54 +0100
Message-ID: <1294670334.11896.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 09:14 -0500, Steven Rostedt wrote:
> > @@ -21,16 +21,6 @@
> >  #undef CREATE_TRACE_POINTS
> 
> But here we undefine CREATE_TRACE_POINTS, why would this cause a problem
> in module.h?

I'm not sure what's happening, all I know is that without this change I
get:

  LD      vmlinux.o
kernel/built-in.o:(__tracepoints+0xac0): multiple definition of `__tracepoint_module_request'
arch/x86/built-in.o:(__tracepoints+0x100): first defined here
kernel/built-in.o:(__tracepoints+0xa40): multiple definition of `__tracepoint_module_get'
arch/x86/built-in.o:(__tracepoints+0x80): first defined here
kernel/built-in.o:(__tracepoints+0x9c0): multiple definition of `__tracepoint_module_load'
arch/x86/built-in.o:(__tracepoints+0x0): first defined here
kernel/built-in.o:(__tracepoints+0xa80): multiple definition of `__tracepoint_module_put'
arch/x86/built-in.o:(__tracepoints+0xc0): first defined here
kernel/built-in.o:(__tracepoints+0xa00): multiple definition of `__tracepoint_module_free'
arch/x86/built-in.o:(__tracepoints+0x40): first defined here

