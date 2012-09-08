Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2IHOPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:15:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63524 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab2IHOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:15:44 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] perf: Enable function tracing for perf core
References: <20120908115515.211175517@goodmis.org>
	<20120908115640.032328533@goodmis.org>
Date: Sat, 08 Sep 2012 23:15:37 +0900
In-Reply-To: <20120908115640.032328533@goodmis.org> (Steven Rostedt's message
	of "Sat, 08 Sep 2012 07:55:16 -0400")
Message-ID: <87627oa9di.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

It seems you missed From: line?

Thanks,
Namhyung

On Sat, 08 Sep 2012 07:55:16 -0400, Steven Rostedt wrote:
> According to Steven R. there is no reason left to not support
> function tracing for the perf core. This makes it easier to debug
> perf.
>
> Don't remove -pg for the x86 and generic perf core.
>
> Link: http://lkml.kernel.org/r/1345306530-25665-2-git-send-email-andi@firstfloor.org
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/cpu/Makefile |    1 -
>  kernel/events/Makefile       |    4 ----
>  2 files changed, 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index d30a6a9..6a16725 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -5,7 +5,6 @@
>  # Don't trace early stages of a secondary CPU boot
>  ifdef CONFIG_FUNCTION_TRACER
>  CFLAGS_REMOVE_common.o = -pg
> -CFLAGS_REMOVE_perf_event.o = -pg
>  endif
>  
>  # Make sure load_percpu_segment has no stackprotector
> diff --git a/kernel/events/Makefile b/kernel/events/Makefile
> index 103f5d1..a630994 100644
> --- a/kernel/events/Makefile
> +++ b/kernel/events/Makefile
> @@ -1,7 +1,3 @@
> -ifdef CONFIG_FUNCTION_TRACER
> -CFLAGS_REMOVE_core.o = -pg
> -endif
> -
>  obj-y := core.o ring_buffer.o callchain.o
>  
>  obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
