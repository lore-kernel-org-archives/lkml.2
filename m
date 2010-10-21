Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0JUUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:16:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755179Ab0JUUQz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:16:55 -0400
MIME-Version: 1.0
In-Reply-To: <20101021132159.GA3284@elte.hu>
References: <20101021132159.GA3284@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Oct 2010 13:16:10 -0700
Message-ID: <AANLkTimLCHhh1TmfpOeju6RcxbCMreh7yQKTZvFj87aF@mail.gmail.com>
Subject: Re: [GIT PULL] x86/asm changes for v2.6.37
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 6:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Jan Beulich (1):
>      i386: Make kernel_execve() suitable for stack unwinding
>
>        long __res;
> -       asm volatile ("push %%ebx ; movl %2,%%ebx ; int $0x80 ; pop %%ebx"
> +       asm volatile ("int $0x80"
>        : "=a" (__res)
> -       : "0" (__NR_execve), "ri" (filename), "c" (argv), "d" (envp) : "memory");
> +       : "0" (__NR_execve), "b" (filename), "c" (argv), "d" (envp) : "memory");
>        return __res;
>  }

I pulled this, but there's a reason we used to do it that way - gcc
has had bugs with inline asm changing %ebx due to some bad interaction
with using it as the GOT base register for position-independent code
or something.

So I hope those are all solved, and I guess we use -fPIC only for some
early boot code. But in case this is ever used in some environment
that is PIC (the vsyscall page?) we need to worry about gcc
interactions.

                   Linus
