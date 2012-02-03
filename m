Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2BCHwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:52:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59948 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2BCHwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:52:03 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mips@linux-mips.org
Subject: [Patch] mips: do not redefine BUILD_BUG()
Date: Fri,  3 Feb 2012 15:51:40 +0800
Message-Id: <1328255503-17575-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mips, we got

include/linux/kernel.h:717:1: error: "BUILD_BUG" redefined
arch/mips/include/asm/page.h:43:1: error: this is the location of the previous definition
make[3]: *** [arch/mips/sgi-ip27/ip27-console.o] Error 1
make[2]: *** [arch/mips/sgi-ip27] Error 2
make[1]: *** [arch/mips] Error 2
make: *** [sub-make] Error 2

use generic BUILD_BUG() instead of re-defining one.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index d417909..e14121a 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -39,9 +39,7 @@
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 #else /* !CONFIG_HUGETLB_PAGE */
-# ifndef BUILD_BUG
-#  define BUILD_BUG() do { extern void __build_bug(void); __build_bug(); } while (0)
-# endif
+#include <linux/kernel.h>
 #define HPAGE_SHIFT	({BUILD_BUG(); 0; })
 #define HPAGE_SIZE	({BUILD_BUG(); 0; })
 #define HPAGE_MASK	({BUILD_BUG(); 0; })
