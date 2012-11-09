Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2KIS3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:29:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab2KIS3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:29:43 -0500
Date: Fri, 9 Nov 2012 19:30:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
Message-ID: <20121109183026.GA2719@redhat.com>
References: <20121109182943.GA2789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109182943.GA2789@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Oleg Nesterov wrote:
>
> Note: TASK_SIZE doesn't look right at least on x86, I think it should
> be replaced by TASK_SIZE_MAX.
> ...
> --- x/arch/x86/kernel/hw_breakpoint.c
> +++ x/arch/x86/kernel/hw_breakpoint.c
> @@ -200,7 +200,7 @@ int arch_check_bp_in_kernelspace(struct
>  	va = info->address;
>  	len = get_hbp_len(info->len);
>
> -	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
> +	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);

But actully I'd like to ask another question.

Can't we add the additional !in_gate_area_no_mm() check to allow
the hw breakpoints in vsyscall?

Quoting Amnon:

	My service needs to catch the system-calls of its traced son.
	Almost all system-calls are caught with PTRACE_SYSCALL, but not those
	using the vsyscall page - especially "gettimeofday()" and "time()".

	...

	However, the code in "arch/x86/kernel/ptrace.c" forbids catching kernel
	addresses.

I tend to agree with Amnon...

What do you think?

Oleg.

