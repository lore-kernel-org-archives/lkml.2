Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1KPVcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:32:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50156 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1KPVcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:32:11 -0500
Date: Wed, 16 Nov 2011 13:32:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        William Irwin <wli@holomorphy.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] hugetlb: Provide a default HPAGE_SHIFT if
 !CONFIG_HUGETLB_PAGE
In-Reply-To: <1321472611-13283-1-git-send-email-ddaney.cavm@gmail.com>
Message-ID: <alpine.DEB.2.00.1111161327180.16596@chino.kir.corp.google.com>
References: <1321472611-13283-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> This is required now to get MIPS kernels to compile with
> !CONFIG_HUGETLB_PAGE.
> 

Why?  Apparently there's some config option you've enabled that is causing 
it to fail but I can't find it.  defconfig works fine on my mips 
crosscompiler and allyesconfig is borked already in other ways.

This is definitely the wrong fix, anyway, and it would require a change to 
arch/mips/include/asm/page.h instead since it's localized to mips, so 
nack.

> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  include/linux/hugetlb.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 19644e0..746d543 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -113,6 +113,7 @@ static inline void copy_huge_page(struct page *dst, struct page *src)
>  #ifndef HPAGE_MASK
>  #define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
>  #define HPAGE_SIZE	PAGE_SIZE
> +#define HPAGE_SHIFT	PAGE_SHIFT
>  #endif
>  
>  #endif /* !CONFIG_HUGETLB_PAGE */
