Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0HSMJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:09:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:53059 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0HSMJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:09:49 -0400
Subject: Re: [GIT PULL] perf callchains updates
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
In-Reply-To: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 14:09:38 +0200
Message-ID: <1282219778.2605.53.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 01:46 +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (6):
>       perf: Drop unappropriate tests on arch callchains
>       perf: Generalize callchain_store()
>       perf: Generalize some arch callchain code
>       perf: Factorize callchain context handling
>       perf: Fix race in callchains
>       perf: Humanize the number of contexts
> 
> Namhyung Kim (1):
>       perf, tracing: add missing __percpu markups
> 
> 
>  arch/arm/kernel/perf_event.c         |   62 +--------
>  arch/powerpc/kernel/perf_callchain.c |   86 ++++--------
>  arch/sh/kernel/perf_callchain.c      |   50 +------
>  arch/sparc/kernel/perf_event.c       |   69 +++------
>  arch/x86/kernel/cpu/perf_event.c     |   82 +++--------
>  include/linux/ftrace_event.h         |    4 +-
>  include/linux/perf_event.h           |   30 +++-
>  kernel/perf_event.c                  |  259 ++++++++++++++++++++++++++++++----
>  kernel/trace/trace_event_perf.c      |   21 ++--
>  kernel/trace/trace_functions_graph.c |    2 +-
>  10 files changed, 342 insertions(+), 323 deletions(-)

/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c: In function ‘perf_callchain_kernel’:
/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c:1645: warning: ‘return’ with a value, in function returning void
/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c: In function ‘perf_callchain_user’:
/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c:1698: warning: ‘return’ with a value, in function returning void


---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1642,7 +1642,7 @@ perf_callchain_kernel(struct perf_callch
 {
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* TODO: We don't support guest os callchain now */
-		return NULL;
+		return;
 	}
 
 	perf_callchain_store(entry, regs->ip);
@@ -1695,7 +1695,7 @@ perf_callchain_user(struct perf_callchai
 
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* TODO: We don't support guest os callchain now */
-		return NULL;
+		return;
 	}
 
 	fp = (void __user *)regs->bp;

