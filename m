Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab2IIXU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:20:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51555 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756440Ab2IIXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:19 -0400
Message-Id: <20120909224153.644601479@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 20/95] ARM: 7488/1: mm: use 5 bits for swapfile type encoding
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f5f2025ef3e2cdb593707cbf87378761f17befbe upstream.

Page migration encodes the pfn in the offset field of a swp_entry_t.
For LPAE, we support physical addresses of up to 36 bits (due to
sparsemem limitations with the size of page flags), requiring 24 bits
to represent a pfn. A further 3 bits are used to encode a swp_entry into
a pte, leaving 5 bits for the type field. Furthermore, the core code
defines MAX_SWAPFILES_SHIFT as 5, so the additional type bit does not
get used.

This patch reduces the width of the type field to 5 bits, allowing us
to create up to 31 swapfiles of 64GB each.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index d88f9f0..41dc31f 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -253,13 +253,13 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
  *
  *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
  *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
- *   <--------------- offset --------------------> <- type --> 0 0 0
+ *   <--------------- offset ----------------------> < type -> 0 0 0
  *
- * This gives us up to 63 swap files and 32GB per swap file.  Note that
+ * This gives us up to 31 swap files and 64GB per swap file.  Note that
  * the offset field is always non-zero.
  */
 #define __SWP_TYPE_SHIFT	3
-#define __SWP_TYPE_BITS		6
+#define __SWP_TYPE_BITS		5
 #define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
 #define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
 


