Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2FTKcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:32:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48050 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2FTKcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:32:16 -0400
Date: Wed, 20 Jun 2012 15:57:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: move function declarations out of arch
Message-ID: <20120620102718.GJ4629@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1340088918-4081-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1340088918-4081-1-git-send-email-rabin.vincent@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062010-6148-0000-0000-000006E0641F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> -extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
> -extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
> -extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
> -extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
>  #endif	/* _ASM_UPROBES_H */
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index efe4b33..e2d2948 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -30,6 +30,8 @@
>  struct vm_area_struct;
>  struct mm_struct;
>  struct inode;
> +struct notifier_block;
> +struct arch_uprobe;
> 

One nit:
Do we need this forward declaration. It should anyway be defined in the
asm/uprobes.h?

>  #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
>  # include <asm/uprobes.h>
> @@ -118,6 +120,13 @@ extern bool uprobe_deny_signal(void);
>  extern bool __weak arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
>  extern void uprobe_clear_state(struct mm_struct *mm);
>  extern void uprobe_reset_state(struct mm_struct *mm);
> +
> +extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
> +extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
> +extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
> +extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
>  #else /* !CONFIG_UPROBES */
>  struct uprobes_state {
>  };

I am okay with moving the declarations to include/linux/uprobes.h

-- 
Thanks and Regards
Srikar

