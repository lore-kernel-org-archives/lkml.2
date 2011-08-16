Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1HPRXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:23:20 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52525 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751847Ab1HPRXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:23:18 -0400
Date: Tue, 16 Aug 2011 10:23:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        rdunlap@xenotime.net, hpa@linux.intel.com
Cc: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [tip:x86/vdso] x86, vsyscall: Add missing <asm/fixmap.h> to
 arch/x86/mm/fault.c
Message-Id: <20110816102314.b37a3474.rdunlap@xenotime.net>
In-Reply-To: <tip-fab1167c4698e3ff11ebb06281d78def6c53728b@git.kernel.org>
References: <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
	<tip-fab1167c4698e3ff11ebb06281d78def6c53728b@git.kernel.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011 15:27:18 GMT tip-bot for H. Peter Anvin wrote:

> Commit-ID:  fab1167c4698e3ff11ebb06281d78def6c53728b
> Gitweb:     http://git.kernel.org/tip/fab1167c4698e3ff11ebb06281d78def6c53728b
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Mon, 15 Aug 2011 22:28:56 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 16 Aug 2011 08:04:02 -0700
> 
> x86, vsyscall: Add missing <asm/fixmap.h> to arch/x86/mm/fault.c
> 
> arch/x86/mm/fault.c now depend on having the symbol VSYSCALL_START
> defined, which is best handled by including <asm/fixmap.h> (it isn't
> unreasonable we may want other fixed addresses in this file in the
> future, and so it is cleaner than including <asm/vsyscall.h>
> directly.)
> 
> This addresses an x86-64 allnoconfig build failure.  On other
> configurations it was masked by an indirect path:
> 
> <asm/smp.h> -> <asm/apic.h> -> <asm/fixmap.h> -> <asm/vsyscall.h>
> 
> ... however, the first such include is conditional on CONFIG_X86_LOCAL_APIC.
> 
> Originally-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Link: http://lkml.kernel.org/r/CA%2B55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5%2BfqMp_exQ@mail.gmail.com

That link gives me:
"No such Message-ID known"

> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/mm/fault.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 247aae3..f2d4c9d 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -17,6 +17,7 @@
>  #include <asm/traps.h>			/* dotraplinkage, ...		*/
>  #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
>  #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
> +#include <asm/fixmap.h>			/* VSYSCALL_START		*/

Nit:  asm/fixmap.h does not provide VSYSCALL_START.  whatever.
>  
>  /*
>   * Page fault error code bits:
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
