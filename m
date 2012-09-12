Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2IMAnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:43:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab2ILXao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:30:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 006/108] ARM: 7488/1: mm: use 5 bits for swapfile type encoding
Date: Wed, 12 Sep 2012 16:28:04 -0700
Message-Id: <20120912232451.108679781@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -253,13 +253,13 @@ static inline pte_t pte_modify(pte_t pte
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
 


