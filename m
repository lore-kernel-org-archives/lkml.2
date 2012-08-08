Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab2HHEfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 00:35:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46050 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2HHEez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 00:34:55 -0400
X-AuditID: b753bd60-928c4ba0000047ca-2c-5021ec6bb12b
X-AuditID: b753bd60-928c4ba0000047ca-2c-5021ec6bb12b
Message-ID: <5021EC6B.7020605@hitachi.com>
Date: Wed, 08 Aug 2012 13:34:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 3/4] ftrace: Do not test frame pointers if -mfentry
 is used
References: <20120807193845.146666357@goodmis.org> <20120807194059.773895870@goodmis.org>
In-Reply-To: <20120807194059.773895870@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/08/08 4:38), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The function graph has a test to check if the frame pointer is
> corrupted, which can happen with various options of gcc with mcount.
> But this is not an issue with -mfentry as -mfentry does not need nor use
> frame pointers for function graph tracing.
> 
> Cc: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_functions_graph.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index ce27c8b..99b4378 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -143,7 +143,7 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
>  		return;
>  	}
>  
> -#ifdef CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST
> +#if defined(CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST) && !defined(CC_USING_FENTRY)

I think CONFIG_HAVE_FENTRY would better unselect
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST in arch/x86/Kconfig explicitly.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


