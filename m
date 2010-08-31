Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0HaArh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:47:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34039 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab0HaArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:47:36 -0400
X-Authority-Analysis: v=1.1 cv=PwepQEbt00S2KBGxbslVOIF+r0Mv8f+EI4NDy2BEsUE= c=1 sm=0 a=EXZQGE_TUQcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Ece4jVXCwC5LhMSh3LUA:9 a=PHcLFvZWeHdUTKFOmgoA:7 a=xBLTx4bYj0v3SEYHu6kof59YNygA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: TRACE: config warning for IRQSOFF_TRACER
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1282402332.1978.32.camel@castor.rsk>
References: <1282402332.1978.32.camel@castor.rsk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 30 Aug 2010 20:47:33 -0400
Message-ID: <1283215653.1377.41.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-21 at 15:52 +0100, Richard Kennedy wrote: 
> In my config with PROVE_LOCKING=n and FTRACE=y (which defaults
> IRQSOFF_TRACER to y), I get the following warning from make oldconfig.
> 
> scripts/kconfig/conf --oldconfig arch/x86/Kconfig
> warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE &&
> TRACE_IRQFLAGS_SUPPORT && !ARCH_USES_GETTIMEOFFSET) selects
> TRACE_IRQFLAGS which has unmet direct dependencies (DEBUG_KERNEL &&
> TRACE_IRQFLAGS_SUPPORT && PROVE_LOCKING)
> 
> The problem is that TRACE_IRQFLAGS depends on PROVE_LOCKING.
> Should it select PROVE_LOCKING instead? or is there a better way to fix
> this?

The TRACE_IRQFLAGS was originally written for lockdep, but it is now
used by Ftrace's irqsoff tracer.

I just compiled and booted with TRACE_IRQFLAGS=y and PROVE_LOCKING not
set, and it worked fine.

I think the correct patch is to remove the dependency of TRACE_IRQFLAGS
on PROVE_LOCKING.

-- Steve


