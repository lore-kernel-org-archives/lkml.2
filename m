Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0HHT6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:58:05 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37024 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab0HHT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QSsXA1DBtF9BdVsgX3Rn8ZlNzdAdscwe6PYoICFUghlD8JBEhNLxgQFciatTyldVCc
         caBo/aqT5tvw4VxRvjgs4ndPI44qZ0V4Q6jViM2Ku7VL9JQSbjc5QiUjMvxVlW0G1Djb
         4epTBEL6sH7b21ybWJxnO8mgxbCtfWUcP+RWQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
Subject: [PATCH] MIPS: remove RELOC_HIDE on __pa_symbol
Date: Mon,  9 Aug 2010 04:57:36 +0900
Message-Id: <1281297456-2711-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unneccessary use of RELOC_HIDE(). It does simple addition of ptr and
offset and in this case (offset 0) does practically nothing. It does NOT do
anything with linker relocation.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/mips/include/asm/page.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index a16beaf..f7e2684 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -150,7 +150,7 @@ typedef struct { unsigned long pgprot; } pgprot_t;
     ((unsigned long)(x) - PAGE_OFFSET + PHYS_OFFSET)
 #endif
 #define __va(x)		((void *)((unsigned long)(x) + PAGE_OFFSET - PHYS_OFFSET))
-#define __pa_symbol(x)	__pa(RELOC_HIDE((unsigned long)(x), 0))
+#define __pa_symbol(x)	__pa(x)
 
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
-- 
1.7.0.4

