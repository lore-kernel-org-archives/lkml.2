Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab2GWEGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 00:06:20 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42317 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2GWEGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 00:06:18 -0400
X-AuditID: b753bd60-936f2ba000004f2e-5c-500ccdb7c2a6
X-AuditID: b753bd60-936f2ba000004f2e-5c-500ccdb7c2a6
Message-ID: <500CCDB5.5000706@hitachi.com>
Date: Mon, 23 Jul 2012 13:06:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Uros Bizjak <ubizjak@gmail.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 07/19] ftrace/x86_32: Simplify parameter setup for
 ftrace_regs_caller
References: <20120721021943.274162381@goodmis.org> <20120721022108.261804403@goodmis.org>
In-Reply-To: <20120721022108.261804403@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/21 11:19), Steven Rostedt wrote:
> From: Uros Bizjak <ubizjak@gmail.com>
> 
> The final position of the stack after saving regs and setting up
> the parameters for ftrace_regs_call, is the position of the pt_regs
> needed for the 4th parameter. Instead of saving it into a temporary
> reg and pushing the reg, simply push the stack pointer.
> 
> Link: http://lkml.kernel.org/r/1342702344.12353.16.camel@gandalf.stny.rr.com
> 

Looks simple and readable :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/entry_32.S |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 46caa56..4dc3017 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1169,10 +1169,9 @@ ENTRY(ftrace_regs_caller)
>  	movl $__KERNEL_CS,13*4(%esp)
>  
>  	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
> -	movl 0x4(%ebp), %edx	/* Load parent ip (2cd parameter) */
> -	lea  (%esp), %ecx
> -	pushl %ecx		/* Save pt_regs as 4th parameter */
> +	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
>  	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
> +	pushl %esp		/* Save pt_regs as 4th parameter */
>  
>  GLOBAL(ftrace_regs_call)
>  	call ftrace_stub
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


