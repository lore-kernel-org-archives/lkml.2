Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab2E0BIj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:08:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182Ab2E0BId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:08:33 -0400
Message-Id: <20120527010428.559186432@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:57 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <richard@nod.at>
Subject: [ 34/94] um: Fix __swp_type()
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 2b76ebaa728f8a3967c52aa189261c72fe56a6f1 upstream.

The current __swp_type() function uses a too small bitshift.
Using more than one swap files causes bad pages because
the type bits clash with other page flags.

Analyzed-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -346,11 +346,11 @@ extern pte_t *virt_to_pte(struct mm_stru
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


