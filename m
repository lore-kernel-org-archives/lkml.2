Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab2ILPaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:30:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759654Ab2ILPaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:30:17 -0400
Date: Wed, 12 Sep 2012 17:30:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH 1/3] mm: thp: Fix the pmd_clear() arguments in
 pmdp_get_and_clear()
Message-ID: <20120912153016.GS21579@dhcp22.suse.cz>
References: <1347382036-18455-1-git-send-email-will.deacon@arm.com>
 <1347382036-18455-2-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347382036-18455-2-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-09-12 17:47:14, Will Deacon wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> The CONFIG_TRANSPARENT_HUGEPAGE implementation of pmdp_get_and_clear()
> calls pmd_clear() with 3 arguments instead of 1.

only for !__HAVE_ARCH_PMDP_GET_AND_CLEAR which doesn't seem to happen
because x86 defines this and it uses pmd_update.

> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steve Capper <steve.capper@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Other than that it looks good.
Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/asm-generic/pgtable.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index ff4947b..f7e0206 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -87,7 +87,7 @@ static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
>  				       pmd_t *pmdp)
>  {
>  	pmd_t pmd = *pmdp;
> -	pmd_clear(mm, address, pmdp);
> +	pmd_clear(pmdp);
>  	return pmd;
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> -- 
> 1.7.4.1
> 

-- 
Michal Hocko
SUSE Labs
