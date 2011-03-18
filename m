Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1CRUHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:07:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35493 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab1CRUHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ctn8wwdF3qNByDM3OdXhwzTsaIiYaMEe03z7Gyno0DyKDIhAfkewwu0T3oOnH1zUHU
         1x09roHUm4T+tWEO8BQrTrc/DnMHqdeYw3xvmbc6NRDYzoqbtvxStNRyoPDqnL0NeDOt
         HK1W5jdKV5SCR5riPSB9nrOy6d5tTzLRRBv6s=
Date: Fri, 18 Mar 2011 20:08:25 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: hans-christian.egtvedt@atmel.com, linux-kernel@vger.kernel.org,
        prasadjoshi124@gmail.com, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 20/22] mm, avr32: add gfp flags variant of pte
 allocations
Message-ID: <20110318200825.GU4746@prasad-kvm>
References: <20110318195754.GK4746@prasad-kvm>
 <20110318195926.GL4746@prasad-kvm>
 <20110318200045.GM4746@prasad-kvm>
 <20110318200150.GN4746@prasad-kvm>
 <20110318200254.GO4746@prasad-kvm>
 <20110318200401.GP4746@prasad-kvm>
 <20110318200452.GQ4746@prasad-kvm>
 <20110318200547.GR4746@prasad-kvm>
 <20110318200638.GS4746@prasad-kvm>
 <20110318200731.GT4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200731.GT4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - Added __pte_alloc_one_kernel to allocate page using specified GFP flag
 - Changed pte_alloc_one_kernel to call __pte_alloc_one_kernel newly added function using GFP_KERNEL allocation flag
 - Helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/avr32/include/asm/pgalloc.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/include/asm/pgalloc.h b/arch/avr32/include/asm/pgalloc.h
index bc7e8ae..cb88080 100644
--- a/arch/avr32/include/asm/pgalloc.h
+++ b/arch/avr32/include/asm/pgalloc.h
@@ -51,10 +51,16 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	quicklist_free(QUICK_PGD, NULL, pgd);
 }
 
+static inline pte_t *__pte_alloc_one_kernel(struct mm_struct *mm,
+					  unsigned long address, gfp_t gfp_mask)
+{
+	return quicklist_alloc(QUICK_PT, gfp_mask, NULL);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
-- 
1.7.0.4

