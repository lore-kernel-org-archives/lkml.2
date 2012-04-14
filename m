Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2DOAAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 20:00:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab2DOAAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 20:00:01 -0400
Date: Sun, 15 Apr 2012 01:59:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <chuckebbert.lk@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ptrace && fpu_lazy_restore
Message-ID: <20120414235933.GA11321@redhat.com>
References: <20120414235238.GA11131@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120414235238.GA11131@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention just in case...

On 04/15, Oleg Nesterov wrote:
>
> --- x/arch/x86/kernel/i387.c~	2012-04-09 20:12:12.000000000 +0200
> +++ x/arch/x86/kernel/i387.c	2012-04-15 01:34:09.000000000 +0200
> @@ -301,6 +301,8 @@ int xfpregs_set(struct task_struct *targ
>
>  	sanitize_i387_state(target);
>
> +	target->thread.fpu.last_cpu = ~0;
> +
>  	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
>  				 &target->thread.fpu.state->fxsave, 0, -1);
>
> @@ -563,6 +565,8 @@ int fpregs_set(struct task_struct *targe
>
>  	sanitize_i387_state(target);
>
> +	target->thread.fpu.last_cpu = ~0;
> +
>  	if (!HAVE_HWFP)
>  		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
>

with this hack the test-case works fine.

Oleg.

