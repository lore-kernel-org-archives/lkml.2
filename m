Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2CYTgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 15:36:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44225 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856Ab2CYTf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 15:35:57 -0400
Message-ID: <4F6F7362.6030402@zytor.com>
Date: Sun, 25 Mar 2012 12:34:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Subject: Re: [PATCH v15 04/13] arch/x86: add syscall_get_arch to syscall.h
References: <1331781125-15658-1-git-send-email-wad@chromium.org> <1331781125-15658-5-git-send-email-wad@chromium.org>
In-Reply-To: <1331781125-15658-5-git-send-email-wad@chromium.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 08:11 PM, Will Drewry wrote:
>  
> +static inline int syscall_get_arch(struct task_struct *task,
> +				   struct pt_regs *regs)
> +{
> +#ifdef CONFIG_IA32_EMULATION
> +	/*
> +	 * TS_COMPAT is set for 32-bit syscall entries and then
> +	 * remains set until we return to user mode.
> +	 *
> +	 * TIF_IA32 tasks should always have TS_COMPAT set at
> +	 * system call time.
> +	 */
> +	if (task_thread_info(task)->status & TS_COMPAT)
> +		return AUDIT_ARCH_I386;
> +#endif
> +	return AUDIT_ARCH_X86_64;
> +}
>  #endif	/* CONFIG_X86_32 */
>  
>  #endif	/* _ASM_X86_SYSCALL_H */

Just one FYI on this: after the x32 changes are upstream this can be
implemented in terms of is_ia32_task().

	-hpa
