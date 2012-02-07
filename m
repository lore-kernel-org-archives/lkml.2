Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2BGAWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:22:18 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab2BGAWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:22:17 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        Artem.Bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/5] um: Serve io_remap_pfn_range()
Date: Tue,  7 Feb 2012 01:22:47 +0100
Message-Id: <1328574170-2286-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1328574170-2286-1-git-send-email-richard@nod.at>
References: <1328574170-2286-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At some places io_remap_pfn_range() is needed.
UML has to serve it like all other archs do.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/pgtable.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/um/include/asm/pgtable.h b/arch/um/include/asm/pgtable.h
index 41474fb..6a3f984 100644
--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -69,6 +69,8 @@ extern unsigned long end_iomem;
 #define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
 
+#define io_remap_pfn_range	remap_pfn_range
+
 /*
  * The i386 can't do page protection for execute, and considers that the same
  * are read.
-- 
1.7.6

