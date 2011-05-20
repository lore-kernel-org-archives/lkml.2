Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1ETUcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:32:51 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:50418 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1ETUcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:32:48 -0400
Message-ID: <4DD6CFB9.6090101@ece.ntua.gr>
Date: Fri, 20 May 2011 23:31:53 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110502 Lightning/1.0b3pre Lanikai/3.1.10
MIME-Version: 1.0
To: Marcus Meissner <meissner@suse.de>
CC: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: powerpc: remove unused variable assignment
References: <20110520091346.GC29499@suse.de>
In-Reply-To: <20110520091346.GC29499@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (ulysses.noc.ntua.gr [147.102.222.230]); Fri, 20 May 2011 23:31:58 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 12:13 PM, Marcus Meissner wrote:
> Hi,
>
> gcc 4.6 with -Werror does not like setting but not using variables
> anymore.
>
> So remove it, it does not seem necessary.
>
> Signed-off-by: Marcus Meissner <meissner@suse.de>
>
> Ciao, Marcus
> ---
>  arch/powerpc/include/asm/pgtable-ppc64.h |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
> index 2b09cd5..c3d39de 100644
> --- a/arch/powerpc/include/asm/pgtable-ppc64.h
> +++ b/arch/powerpc/include/asm/pgtable-ppc64.h
> @@ -257,21 +257,17 @@ static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
>  static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
>  				      pte_t *ptep)
>  {
> -	unsigned long old;
> -
>         	if ((pte_val(*ptep) & _PAGE_RW) == 0)
>         		return;
> -	old = pte_update(mm, addr, ptep, _PAGE_RW, 0);
> +	pte_update(mm, addr, ptep, _PAGE_RW, 0);
>  }
>  
>  static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
>  					   unsigned long addr, pte_t *ptep)
>  {
> -	unsigned long old;
> -
>  	if ((pte_val(*ptep) & _PAGE_RW) == 0)
>  		return;
> -	old = pte_update(mm, addr, ptep, _PAGE_RW, 1);
> +	pte_update(mm, addr, ptep, _PAGE_RW, 1);
>  }
>  
>  /*
It's already in the ppc repo [1]. And going to be merged in 2.6.40 I
think. :)

[1]
http://git.kernel.org/?p=linux/kernel/git/benh/powerpc.git;a=commit;h=2a2c29c1a581319f4485af55e8d628d89e8f2583


-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

