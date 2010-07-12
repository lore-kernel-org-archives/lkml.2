Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0GLMuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 08:50:14 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:1059 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0GLMuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 08:50:12 -0400
X-IronPort-AV: E=Sophos;i="4.55,188,1278288000"; 
   d="scan'208";a="850869"
Date: Mon, 12 Jul 2010 13:50:41 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove mmu notifier calls in apply_to_page_range
In-Reply-To: <4C376013.7020208@goop.org>
Message-ID: <alpine.DEB.2.00.1007121343510.21432@kaball-desktop>
References: <4C376013.7020208@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, Jeremy Fitzhardinge wrote:
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6ab19dd..d6b89eb 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1890,7 +1890,6 @@ int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
>  	int err;
>  
>  	BUG_ON(addr >= end);
> -	mmu_notifier_invalidate_range_start(mm, start, end);
>  	pgd = pgd_offset(mm, addr);
>  	do {
>  		next = pgd_addr_end(addr, end);
> @@ -1898,7 +1897,7 @@ int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
> -	mmu_notifier_invalidate_range_end(mm, start, end);
> +
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(apply_to_page_range);
> 
> 
> 

The local variable start in apply_to_page_range is not used anymore:
remove it.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---

diff --git a/mm/memory.c b/mm/memory.c
index 9d33bfe..0a47927 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1989,7 +1989,7 @@ int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long start = addr, end = addr + size;
+	unsigned long end = addr + size;
 	int err;
 
 	BUG_ON(addr >= end);
