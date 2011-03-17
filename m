Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1CQRB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:01:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44614 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1CQRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:01:57 -0400
Date: Thu, 17 Mar 2011 13:01:53 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tony@atomide.com, joe@perches.com,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Subject: Re: [PATCH v2] arm: cmpxchg syscall should data abort if page not
 write
In-Reply-To: <1300169637-1628-1-git-send-email-ratbert.chuang@gmail.com>
Message-ID: <alpine.LFD.2.00.1103171301030.26889@xanadu.home>
References: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com> <1300169637-1628-1-git-send-email-ratbert.chuang@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Po-Yu Chuang wrote:

> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> If the page to cmpxchg is user mode read only (not write),
> we should simulate a data abort first.
> 
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

> ---
> v2:
> remove !pte_young() check
> 
>  arch/arm/kernel/traps.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 446aee9..eac7c05 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -563,7 +563,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
>  		if (!pmd_present(*pmd))
>  			goto bad_access;
>  		pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> -		if (!pte_present(*pte) || !pte_dirty(*pte)) {
> +		if (!pte_present(*pte) || !pte_write(*pte) || !pte_dirty(*pte)) {
>  			pte_unmap_unlock(pte, ptl);
>  			goto bad_access;
>  		}
> -- 
> 1.6.3.3
> 
