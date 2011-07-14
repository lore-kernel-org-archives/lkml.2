Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1GNWcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:32:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455Ab1GNWcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:32:05 -0400
Date: Thu, 14 Jul 2011 15:31:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Waychison <mikew@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
Message-Id: <20110714153113.31ffdeea.akpm@linux-foundation.org>
In-Reply-To: <1310675693-9204-2-git-send-email-mikew@google.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
	<1310675693-9204-2-git-send-email-mikew@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 13:34:53 -0700
Mike Waychison <mikew@google.com> wrote:

> --- a/arch/x86/kernel/ioport.c
> +++ b/arch/x86/kernel/ioport.c
> @@ -17,6 +17,7 @@
>  #include <linux/bitmap.h>
>  #include <asm/syscalls.h>
>  
> +#ifdef CONFIG_X86_SYS_IOPL
>  /*
>   * this changes the io permissions bitmap in the current task.
>   */
> @@ -111,3 +112,14 @@ long sys_iopl(unsigned int level, struct pt_regs *regs)
>  
>  	return 0;
>  }
> +
> +#else /* CONFIG_X86_SYS_IOPL */
> +
> +asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on) {
> +	return -ENOSYS;
> +}
> +
> +long sys_iopl(unsigned int level, struct pt_regs *regs) {
> +	return -ENOSYS;
> +}
> +#endif /* CONFIG_X86_SYS_IOPL */

sys_iopl() is missing asmlinkage.

It would be far more conventional to use cond_syscall().  Perhaps by
adding a CONFIG_X86 area into kernel/sys_ni.c

fyi, I'm offering special deals on checkpatch.pl site licenses this month.
