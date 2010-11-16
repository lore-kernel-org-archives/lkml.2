Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab0KPKRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:17:42 -0500
Received: from mail4.comsite.net ([205.238.176.238]:50785 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934160Ab0KPKRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:17:41 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: Re: Corrected data type mismatch
From: Milton Miller <miltonm@bga.com>
X-Patchwork-Id: 323022
Message-Id: <mdm-kgbd-badfix@mdm.bga.com>
In-Reply-To: <1289700419-11072-2-git-send-email-shan.hai@windriver.com>
References: <1289700419-11072-2-git-send-email-shan.hai@windriver.com>
To: Hai Shan <shan.hai@windriver.com>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        <kgdb-bugreport@lists.sourceforge.net>
Date: Tue, 16 Nov 2010 04:17:25 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added cc's based on from ff10b88b5a05c8f1646dd15fb9f6093c1384ff6d,
which added the patched line ]

https://patchwork.kernel.org/patch/323022/

On Sun, 14 Nov 2010 around 02:06:59 -0000, Hai Shan wrote:
> 
> Corrected data type mismatch
> 
This merely hides the type mismatch by force casting it.

Looking at the context I believe the intent is to copy the the value to
or from the register content slot, not take the previous value of the
register and use that as an address to copy to or from.

milton
> Signed-off-by: Hai Shan <shan.hai@windriver.com>
> 
> ---
> arch/powerpc/kernel/kgdb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index 7a9db64..c5ce65f 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -337,7 +337,7 @@ char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
>  		/* FP registers 32 -> 63 */
>  #if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
>  		if (current)
> -			memcpy(mem, current->thread.evr[regno-32],
> +			memcpy(mem, (void *)current->thread.evr[regno-32],
>  					dbg_reg_def[regno].size);
>  #else
>  		/* fp registers not used by kernel, leave zero */
> @@ -362,7 +362,7 @@ int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
>  	if (regno >= 32 && regno < 64) {
>  		/* FP registers 32 -> 63 */
>  #if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
> -		memcpy(current->thread.evr[regno-32], mem,
> +		memcpy((void *)current->thread.evr[regno-32], mem,
>  				dbg_reg_def[regno].size);
>  #else
>  		/* fp registers not used by kernel, leave zero */
