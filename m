Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2IBVeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:34:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46129 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab2IBVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:33:10 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 6/7] x86, iommu: drop duplicate const in __IOMMU_INIT
Date: Sun,  2 Sep 2012 23:31:45 +0200
Message-Id: <1346621506-30857-7-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's redundant and makes sparse complain about it.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/include/asm/iommu_table.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index f229b13..bbf8fb2 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -48,7 +48,7 @@ struct iommu_table_entry {
 
 
 #define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
-	static const struct iommu_table_entry const			\
+	static const struct iommu_table_entry				\
 		__iommu_entry_##_detect __used				\
 	__attribute__ ((unused, __section__(".iommu_table"),		\
 			aligned((sizeof(void *)))))	\
-- 
1.7.10.4

