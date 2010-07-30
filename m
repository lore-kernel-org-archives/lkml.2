Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab0G3Xov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:44:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:54256 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0G3Xou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:44:50 -0400
Subject: Re: [PATCH 10/15] powerpc: Replace hardcoded offset by
 BREAK_INSTR_SIZE
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        mingo@elte.hu, Michal Simek <monstr@monstr.eu>,
        linuxppc-dev@ozlabs.org
In-Reply-To: <1280517456-1167-11-git-send-email-jason.wessel@windriver.com>
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
	 <1280517456-1167-11-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 09:44:23 +1000
Message-ID: <1280533463.1902.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 14:17 -0500, Jason Wessel wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> kgdb_handle_breakpoint checks the first arch_kgdb_breakpoint
> which is not known by gdb that's why is necessary jump over
> it. The jump lenght is equal to BREAK_INSTR_SIZE that's
> why is cleaner to use defined macro instead of hardcoded
> non-described offset.

Yeah well, all powerpc instructions are 4 bytes :-) But the
patch is fine.

> Signed-off-by: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: linuxppc-dev@ozlabs.org
> ---
>  arch/powerpc/kernel/kgdb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index 82a7b22..7f61a3a 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -129,7 +129,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
>  		return 0;
>  
>  	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
> -		regs->nip += 4;
> +		regs->nip += BREAK_INSTR_SIZE;
>  
>  	return 1;
>  }


