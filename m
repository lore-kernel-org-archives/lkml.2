Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1DCPTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 11:19:10 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33971 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1DCPTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 11:19:08 -0400
From: Florian Mickler <florian@mickler.org>
To: x86@kernel.org
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, numa_64: remove unused variable
Date: Sun,  3 Apr 2011 17:13:34 +0200
Message-Id: <1301843624-22364-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case !CONFIG_ACPI_NUMA and !CONFIG_AMD_NUMA gcc emits a warning about
the unused variable ret.

As that variable is in fact not needed I choose to remove it.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 arch/x86/mm/numa_64.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index e8c00cc..0916976 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -626,17 +626,13 @@ static int __init numa_init(int (*init_func)(void))
 
 void __init initmem_init(void)
 {
-	int ret;
-
 	if (!numa_off) {
 #ifdef CONFIG_ACPI_NUMA
-		ret = numa_init(x86_acpi_numa_init);
-		if (!ret)
+		if (!numa_init(x86_acpi_numa_init))
 			return;
 #endif
 #ifdef CONFIG_AMD_NUMA
-		ret = numa_init(amd_numa_init);
-		if (!ret)
+		if (!numa_init(amd_numa_init))
 			return;
 #endif
 	}
-- 
1.7.4.1

