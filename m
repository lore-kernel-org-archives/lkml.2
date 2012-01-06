Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab2AFAEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:04:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab2AFAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:04:50 -0500
Date: Thu, 5 Jan 2012 16:04:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120105160448.dc482ef6.akpm@linux-foundation.org>
In-Reply-To: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
References: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012 19:04:05 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi ,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> In file included from include/trace/ftrace.h:567:0,
>                  from include/trace/define_trace.h:86,
>                  from include/trace/events/power.h:240,
>                  from kernel/trace/power-traces.c:14:
> include/trace/events/kmem.h: In function 'ftrace_test_probe_kmalloc':
> include/trace/events/kmem.h:45:1: error: implicit declaration of function 'check_trace_callback_type_kmalloc' [-Werror=implicit-function-declaration]
> include/trace/events/kmem.h: In function 'ftrace_test_probe_kmem_cache_alloc':
>
> ...
>
> include/trace/events/kmem.h:267:1: error: implicit declaration of function 'check_trace_callback_type_mm_page_alloc_extfrag' [-Werror=implicit-function-declaration]
> In file included from include/trace/ftrace.h:774:0,
>                  from include/trace/define_trace.h:86,
>                  from include/trace/events/power.h:240,
>                  from kernel/trace/power-traces.c:14:
> include/trace/events/kmem.h: In function 'perf_test_probe_mm_page_pcpu_drain':
> include/trace/events/kmem.h:256:1: error: implicit declaration of function 'check_trace_callback_type_mm_page_pcpu_drain' [-Werror=implicit-function-declaration]
> 
> I have no idea what has gone wrong here, but I did not get this error
> yesterday.  The only thing that touched include/trace/events/kmem.h is
> patch "mm-tracepoint: rename page-free events" from the akpm tree, but
> that was there yesterday as well and doesn't look suspicious.

Yes, it's not due to anything in the akpm tree.  Tracing stuff blew up.

> I just have to leave things broken for today in the hope that someone
> figures something out.  This does not affect my X86_64 allmodconfig build
> or my PowerPC builds (including an allyesconfig build).

It fails with sparc64 defconfig but succeeds with sparc64 allmodconfig.
Some config-dependent thing.  3.2 is OK, so it's something in -next.

It could be that some far-off sparc64 Kconfig change is newly
triggering this.  

I suppose I could get off my ass and actually work out why it broke,
but the tracing code is too icky.

