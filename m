Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1HYUVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:21:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50072 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1HYUVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:21:09 -0400
MIME-Version: 1.0
In-Reply-To: <0a627e9f49e26554cacdb4049e4c09fa94ca76b6.1314302910.git.luto@mit.edu>
References: <CAObL_7HLpji6xDcBAmwUXBQuahLLVzQXAfYz_gXufUqj_cDzeQ@mail.gmail.com>
	<0a627e9f49e26554cacdb4049e4c09fa94ca76b6.1314302910.git.luto@mit.edu>
Date: Thu, 25 Aug 2011 16:21:08 -0400
Message-ID: <CACqU3MUc3RSk8GTLRbsE=mY8o=K74B8PTFiVrhqCq9cCej92TA@mail.gmail.com>
Subject: Re: [PATCH] x86-32: Fix boot with CONFIG_X86_INVD_BUG
From: Arnaud Lacombe <lacombar@gmail.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 25, 2011 at 4:10 PM, Andy Lutomirski <luto@mit.edu> wrote:
> entry_32.S contained a hardcoded alternative instruction entry, and
> the format changed in:
>
> commit 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
> Author: Andy Lutomirski <luto@mit.edu>
> Date:   Wed Jul 13 09:24:10 2011 -0400
>
>    x86: Make alternative instruction pointers relative
>
> Replace it with the altinstruction_entry macro.  This fixes the
> 32-bit boot with CONFIG_X86_INVD_BUG=y.
>
> Reported-by: Arnaud Lacombe <lacombar@gmail.com>
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>
> Arnaud, can you test this?
>
All good.

Tested-by: Arnaud Lacombe <lacombar@gmail.com>

Thanks!
 - Arnaud

> Thanks,
> Andy
>
>  arch/x86/kernel/entry_32.S |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 5c1a9197..f3f6f53 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -54,6 +54,7 @@
>  #include <asm/ftrace.h>
>  #include <asm/irq_vectors.h>
>  #include <asm/cpufeature.h>
> +#include <asm/alternative-asm.h>
>
>  /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
>  #include <linux/elf-em.h>
> @@ -873,12 +874,7 @@ ENTRY(simd_coprocessor_error)
>  661:   pushl_cfi $do_general_protection
>  662:
>  .section .altinstructions,"a"
> -       .balign 4
> -       .long 661b
> -       .long 663f
> -       .word X86_FEATURE_XMM
> -       .byte 662b-661b
> -       .byte 664f-663f
> +       altinstruction_entry 661b, 663f, X86_FEATURE_XMM, 662b-661b, 664f-663f
>  .previous
>  .section .altinstr_replacement,"ax"
>  663:   pushl $do_simd_coprocessor_error
> --
> 1.7.6
>
>
