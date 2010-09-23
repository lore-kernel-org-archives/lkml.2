Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab0IWWii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:38:38 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5483 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab0IWWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:36 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 8/9] MIPS: Add a platform hook for swiotlb setup.
Date: Thu, 23 Sep 2010 15:38:15 -0700
Message-Id: <1285281496-24696-9-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 23 Sep 2010 22:38:35.0956 (UTC) FILETIME=[0F318740:01CB5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows platforms that are using the swiotlb to initialize it.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/include/asm/bootinfo.h |    5 +++++
 arch/mips/kernel/setup.c         |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/bootinfo.h b/arch/mips/include/asm/bootinfo.h
index 15a8ef0..b3cf989 100644
--- a/arch/mips/include/asm/bootinfo.h
+++ b/arch/mips/include/asm/bootinfo.h
@@ -125,4 +125,9 @@ extern unsigned long fw_arg0, fw_arg1, fw_arg2, fw_arg3;
  */
 extern void plat_mem_setup(void);
 
+/*
+ * Optional platform hook to call swiotlb_setup().
+ */
+extern void plat_swiotlb_setup(void);
+
 #endif /* _ASM_BOOTINFO_H */
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 85aef3f..8b650da 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -488,6 +488,11 @@ static void __init arch_mem_init(char **cmdline_p)
 
 	bootmem_init();
 	sparse_init();
+
+#ifdef CONFIG_SWIOTLB
+	plat_swiotlb_setup();
+#endif
+
 	paging_init();
 }
 
-- 
1.7.2.2

