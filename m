Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2E1DqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:46:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52042 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862Ab2E1D32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:28 -0400
Message-Id: <20120528031212.256834936@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <richard@nod.at>
Subject: [ 068/117] um: Fix __swp_type()
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 2b76ebaa728f8a3967c52aa189261c72fe56a6f1 upstream.

The current __swp_type() function uses a too small bitshift.
Using more than one swap files causes bad pages because
the type bits clash with other page flags.

Analyzed-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/um/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/asm/pgtable.h b/arch/um/include/asm/pgtable.h
index 294254e..5888f1b 100644
--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -354,11 +354,11 @@ extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
 #define update_mmu_cache(vma,address,ptep) do ; while (0)
 
 /* Encode and de-code a swap entry */
-#define __swp_type(x)			(((x).val >> 4) & 0x3f)
+#define __swp_type(x)			(((x).val >> 5) & 0x1f)
 #define __swp_offset(x)			((x).val >> 11)
 
 #define __swp_entry(type, offset) \
-	((swp_entry_t) { ((type) << 4) | ((offset) << 11) })
+	((swp_entry_t) { ((type) << 5) | ((offset) << 11) })
 #define __pte_to_swp_entry(pte) \
 	((swp_entry_t) { pte_val(pte_mkuptodate(pte)) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })


