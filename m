Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423615Ab2KOJkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:40:33 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60754 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217Ab2KOJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:40:30 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
Date: Thu, 15 Nov 2012 17:39:56 +0800
Message-ID: <1352972396-13489-7-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352972396-13489-1-git-send-email-tiejun.chen@windriver.com>
References: <1352972396-13489-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Book3e is always aligned 1GB to create TLB so we should
use (KERNELBASE - MEMORY_START) as VIRT_PHYS_OFFSET to
get __pa/__va properly while boot kdump.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/include/asm/page.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index f072e97..2cba08a 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -112,6 +112,8 @@ extern long long virt_phys_offset;
 /* See Description below for VIRT_PHYS_OFFSET */
 #ifdef CONFIG_RELOCATABLE_PPC32
 #define VIRT_PHYS_OFFSET virt_phys_offset
+#elif defined(CONFIG_PPC_BOOK3E_64)
+#define VIRT_PHYS_OFFSET (KERNELBASE - MEMORY_START)
 #else
 #define VIRT_PHYS_OFFSET (KERNELBASE - PHYSICAL_START)
 #endif
-- 
1.7.9.5

