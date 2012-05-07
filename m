Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab2EGQyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:54:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab2EGQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:53:59 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=2PfWfQ4LHIYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=Vw2N8DggyjALpdZny7cA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336409637.14207.153.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL] ftrace/x86: Use asm/kprobes.h instead of
 linux/kprobes.h
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 07 May 2012 12:53:57 -0400
In-Reply-To: <1336139384.14207.114.camel@gandalf.stny.rr.com>
References: <1336139384.14207.114.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, I forgot to update the subject (fixed)

Anyway, Ingo, can you pull this.

Thanks!

-- Steve


On Fri, 2012-05-04 at 09:49 -0400, Steven Rostedt wrote:
> Ingo,
> 
> This is based on top of tip/perf/core-3, and fixes the compile error
> that you saw with CONFIG_KPROBES disabled.
> 
> Please pull the latest tip/perf/core-4 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core-4
> 
> Head SHA1: 59a094c994a138049b41a44bc29cff9407d51c5b
> 
> 
> Steven Rostedt (1):
>       ftrace/x86: Use asm/kprobes.h instead of linux/kprobes.h
> 
> ----
>  arch/x86/kernel/ftrace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> ---------------------------
> commit 59a094c994a138049b41a44bc29cff9407d51c5b
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Fri May 4 09:26:16 2012 -0400
> 
>     ftrace/x86: Use asm/kprobes.h instead of linux/kprobes.h
>     
>     If CONFIG_KPROBES is not set, then linux/kprobes.h will not include
>     asm/kprobes.h needed by x86/ftrace.c for the BREAKPOINT macro.
>     
>     The x86/ftrace.c file should just include asm/kprobes.h as it does not
>     need the rest of kprobes.
>     
>     Reported-by: Ingo Molnar <mingo@elte.hu>
>     Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index cf2d03e..4243e8b 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -20,11 +20,11 @@
>  #include <linux/init.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
> -#include <linux/kprobes.h>
>  
>  #include <trace/syscall.h>
>  
>  #include <asm/cacheflush.h>
> +#include <asm/kprobes.h>
>  #include <asm/ftrace.h>
>  #include <asm/nops.h>
>  
> 


