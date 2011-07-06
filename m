Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1GFJg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:36:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40569 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab1GFJg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:36:26 -0400
MIME-Version: 1.0
In-Reply-To: <1309870814-14181-3-git-send-email-ian.campbell@citrix.com>
References: <20110705111525.GR17941@sun>
	<1309870814-14181-3-git-send-email-ian.campbell@citrix.com>
Date: Wed, 6 Jul 2011 12:36:25 +0300
X-Google-Sender-Auth: aAJwF6rEgK53QIbSnKABpRtnjVk
Message-ID: <CAOJsxLH=LMASd9cZJQhJHUuXeArQxWhHt65xg39P5=6KySOV-g@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: ret_from_fork: use symbolic contants for bits in EFLAGS
From: Pekka Enberg <penberg@kernel.org>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 4:00 PM, Ian Campbell <ian.campbell@citrix.com> wrote:
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: x86@kernel.org
> ---
>  arch/x86/kernel/entry_32.S |    2 +-
>  arch/x86/kernel/entry_64.S |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 5c1a9197..f032530 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -303,7 +303,7 @@ ENTRY(ret_from_fork)
>        call schedule_tail
>        GET_THREAD_INFO(%ebp)
>        popl_cfi %eax
> -       pushl_cfi $0x0202               # Reset kernel eflags
> +       pushl_cfi $(X86_EFLAGS_IF|0x2)  # Reset kernel eflags
>        popfl_cfi
>        jmp syscall_exit
>        CFI_ENDPROC
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 9c28bd5..4c76abf 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -399,7 +399,7 @@ ENTRY(ret_from_fork)
>
>        call schedule_tail                      # rdi: 'prev' task parameter
>
> -       pushq_cfi $0x0202
> +       pushq_cfi $(X86_EFLAGS_IF|0x2)
>        popfq_cfi                               # reset kernel eflags
>
>        GET_THREAD_INFO(%rcx)

Reviewed-by: Pekka Enberg <penberg@kernel.org>
