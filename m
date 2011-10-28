Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1J1BuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 21:50:08 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34164 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1J1BuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 21:50:07 -0400
X-AuditID: b753bd60-a0aaaba0000019f4-1e-4eaa0a4b3f4e
X-AuditID: b753bd60-a0aaaba0000019f4-1e-4eaa0a4b3f4e
Message-ID: <4EAA0A3D.90102@hitachi.com>
Date: Fri, 28 Oct 2011 10:49:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH x86 2/2] Cleanup do_int3
References: <20111025141812.GA21225@linux.vnet.ibm.com> <20111025142159.GB21225@linux.vnet.ibm.com>
In-Reply-To: <20111025142159.GB21225@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/25 23:21), Srikar Dronamraju wrote:
> Since there is a possibility of !KPROBES int3 listeners and since
> DIE_TRAP is currently not being used by anybody, notify all listeners
> with DIE_INT3.

I'm not sure why this CONFIG_KPROBES dependency had been introduced,
but it's the time to fix it. do_int3 should send DIE_INT3 always.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/traps.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 6913369..c9a4be5 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -461,15 +461,10 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
>  			== NOTIFY_STOP)
>  		return;
>  #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
> -#ifdef CONFIG_KPROBES
> +
>  	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
>  			== NOTIFY_STOP)
>  		return;
> -#else
> -	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
> -			== NOTIFY_STOP)
> -		return;
> -#endif
>  
>  	preempt_conditional_sti(regs);
>  	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
