Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab1CRUHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:07:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47143 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab1CRUGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bVmWDdMqo01wrfdOWGg5TkYozcyXoeKLXQjDBTltkCikdYipfUSaxSJigVnewt0AKU
         3Fx9JSZO+cQnONBaE9aQEZtfMmEv5Di+7IQyz6cO9hDEeA1MyANEBnlKKn9gGyDMRPo8
         EEYD6QTfWi0DfVda3bBu1k++F0slI0gH1fH7k=
Date: Fri, 18 Mar 2011 20:07:31 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: starvik@axis.com, jesper.nilsson@axis.com, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 19/22] mm, cris: add gfp flags variant of pte
 allocations
Message-ID: <20110318200731.GT4746@prasad-kvm>
References: <20110318195643.GJ4746@prasad-kvm>
 <20110318195754.GK4746@prasad-kvm>
 <20110318195926.GL4746@prasad-kvm>
 <20110318200045.GM4746@prasad-kvm>
 <20110318200150.GN4746@prasad-kvm>
 <20110318200254.GO4746@prasad-kvm>
 <20110318200401.GP4746@prasad-kvm>
 <20110318200452.GQ4746@prasad-kvm>
 <20110318200547.GR4746@prasad-kvm>
 <20110318200638.GS4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200638.GS4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - Added __pte_alloc_one_kernel to allocate page using specified GFP flag
 - Changed pte_alloc_one_kernel to call __pte_alloc_one_kernel using GFP_KERNEL allocation flag
 - Helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/cris/include/asm/pgalloc.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/cris/include/asm/pgalloc.h b/arch/cris/include/asm/pgalloc.h
index 6da975d..20254ee 100644
--- a/arch/cris/include/asm/pgalloc.h
+++ b/arch/cris/include/asm/pgalloc.h
@@ -22,10 +22,16 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_page((unsigned long)pgd);
 }
 
+static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, 
+	gfp_t gfp_mask)
+{
+  	return (pte_t *) __get_free_page(gfp_mask | __GFP_ZERO);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-  	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
- 	return pte;
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
-- 
1.7.0.4

