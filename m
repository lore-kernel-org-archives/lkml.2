Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2ILMcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:32:01 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46216 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab2ILMb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:31:59 -0400
Date: Wed, 12 Sep 2012 17:57:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes: Make arch_uprobe_task->saved_trap_nr
 "unsigned int"
Message-ID: <20120912122754.GB9582@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120903152525.GA9028@redhat.com>
 <20120903152620.GA9088@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120903152620.GA9088@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091212-7182-0000-0000-000002987503
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-03 17:26:20]:

> Make arch_uprobe_task->saved_trap_nr "unsigned int" and move it down
> after ->saved_scratch_register, this changes sizeof() from 24 to 16.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/x86/include/asm/uprobes.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index d561ff5..8ff8be7 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -42,10 +42,10 @@ struct arch_uprobe {
>  };
> 
>  struct arch_uprobe_task {
> -	unsigned long			saved_trap_nr;
>  #ifdef CONFIG_X86_64
>  	unsigned long			saved_scratch_register;
>  #endif
> +	unsigned int			saved_trap_nr;
>  	unsigned int			saved_tf;
>  };
> 
> -- 
> 1.5.5.1
> 

