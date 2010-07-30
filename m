Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab0G3MAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 08:00:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:64110 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab0G3MAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 08:00:16 -0400
Message-ID: <4C52BEA2.8030302@windriver.com>
Date: Fri, 30 Jul 2010 06:59:30 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/23] KGDB: Remove set but unused newPC
References: <20100610110.764742110@firstfloor.org> <20100610111044.0E350B1A2B@basil.firstfloor.org>
In-Reply-To: <20100610111044.0E350B1A2B@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2010 11:59:31.0859 (UTC) FILETIME=[AB9C6630:01CB2FDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/10/2010 06:10 AM, Andi Kleen wrote:
> I'm not fully sure this is the correct fix, maybe this
> was a bug and newPC should really have a side effect.
> Jason?
>
>   
Andi,

This looks fine to me.  The newPC got there from the merge of the 32/64
kgdb specific implementation.   Definitely don't need it anymore.

I'll queue it for 2.6.36.

Thanks,
Jason.

> Found by gcc 4.6's new warnings
>
> Cc: jason.wessel@windriver.com
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  arch/x86/kernel/kgdb.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> Index: linux-2.6.35-rc2-gcc/arch/x86/kernel/kgdb.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/arch/x86/kernel/kgdb.c
> +++ linux-2.6.35-rc2-gcc/arch/x86/kernel/kgdb.c
> @@ -458,7 +458,6 @@ int kgdb_arch_handle_exception(int e_vec
>  {
>  	unsigned long addr;
>  	char *ptr;
> -	int newPC;
>  
>  	switch (remcomInBuffer[0]) {
>  	case 'c':
> @@ -469,8 +468,6 @@ int kgdb_arch_handle_exception(int e_vec
>  			linux_regs->ip = addr;
>  	case 'D':
>  	case 'k':
> -		newPC = linux_regs->ip;
> -
>  		/* clear the trace bit */
>  		linux_regs->flags &= ~X86_EFLAGS_TF;
>  		atomic_set(&kgdb_cpu_doing_single_step, -1);
>   

