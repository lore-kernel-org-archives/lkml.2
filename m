Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1HPGnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:43:24 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:41706 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1HPGnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <tip-87cae8456a55c0a6163deca66d8aa3a6aa21f764@git.kernel.org>
References: <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
	<tip-87cae8456a55c0a6163deca66d8aa3a6aa21f764@git.kernel.org>
Date: Tue, 16 Aug 2011 09:43:19 +0300
X-Google-Sender-Auth: SrDQJyCDT6rd4yokvIvhYTmiM-4
Message-ID: <CAOJsxLFH6=OtDO8VErc1A_Waf89bRO53_Axnecc06TrUGmLZ1g@mail.gmail.com>
Subject: Re: [tip:x86/vdso] x86, vsyscall: Add missing <asm/fixmap.h> to arch/x86/mm/fault.c
From: Pekka Enberg <penberg@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        rdunlap@xenotime.net, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 9:20 AM, tip-bot for H. Peter Anvin
<hpa@linux.intel.com> wrote:
> Commit-ID:  87cae8456a55c0a6163deca66d8aa3a6aa21f764
> Gitweb:     http://git.kernel.org/tip/87cae8456a55c0a6163deca66d8aa3a6aa21f764
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Mon, 15 Aug 2011 22:28:56 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Mon, 15 Aug 2011 22:28:56 -0700
>
> x86, vsyscall: Add missing <asm/fixmap.h> to arch/x86/mm/fault.c
>
> arch/x86/mm/fault.c now depend on having the symbol VSYSCALL_START
> defined, which is best handled by including <asm/fixmap.h> (it isn't
> unreasonable we may want other fixed addresses in this file in the
> future, and so it is cleaner than including <asm/vsyscall.h>
> directly.)
>
> This addresses an x86-64 allnoconfig build failure.  On other
> configurations it was masked by an indirect path:
>
> <asm/smp.h> -> <asm/apic.h> -> <asm/fixmap.h> -> <asm/vsyscall.h>
>
> ... however, the first such include is conditional on CONFIG_X86_LOCAL_APIC.
>
> Originally-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Link: http://lkml.kernel.org/r/CA%2B55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5%2BfqMp_exQ@mail.gmail.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/mm/fault.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 247aae3..bb3f8ca 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -17,6 +17,7 @@
>  #include <asm/traps.h>                 /* dotraplinkage, ...           */
>  #include <asm/pgalloc.h>               /* pgd_*(), ...                 */
>  #include <asm/kmemcheck.h>             /* kmemcheck_*(), ...           */
> +#include <asm/vsyscall.h>              /* VSYSCALL_START               */

The commit subject line says <asm/fixmap.h> which is wrong, right?

                             Pekka
