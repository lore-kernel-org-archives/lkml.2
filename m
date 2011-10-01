Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1JATXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:23:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab1JATXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:23:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/11] ARM: export rtc_lock for nvram driver
Date: Sat,  1 Oct 2011 21:21:50 +0200
Message-Id: <1317496920-7764-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:K5KuNQtx+V3WSd7gdMtbfz4Et7u5HEMdS6IlKGimuhW
 Pq3tQOyScmVivnEeExNFPFgXLdtSlVNmvqQSzr7LEyhbfstEdZ
 4qcUy2ZquQx+Ri6lcqzlBKK4pN0xSRl1kdzkjS3NkfxVHgdFP2
 vTZ4KFwfDcF5DjEbKTLByEja9/HdgzjefVRvGCEglobw2PWqjW
 +enGhVD3nE5Ew0fmbTV9yRSfL50DF8K52tbe4T99qHbyILLG7e
 IKV174HQLStOM8xyrEul4B1AuAGlP7e0DISCKb3zPuZPWEPfsh
 e06SvQqkN4i+GeekufHrxHmj+wNrDuS3QKOc7dNsa9y9drmQi6
 M/OGYaaKfs4qI4Mrc442lqLF7ODSUyYg4Jy+Ynqtc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc_lock is used by both the nvram and rtc drivers, so
we need to export it if at least one of the two is built,
not just for the rtc driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/kernel/time.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index cb634c3..5a54b95 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -39,13 +39,11 @@
  */
 static struct sys_timer *system_timer;
 
-#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
+#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || \
+    defined(CONFIG_NVRAM) || defined(CONFIG_NVRAM_MODULE)
 /* this needs a better home */
 DEFINE_SPINLOCK(rtc_lock);
-
-#ifdef CONFIG_RTC_DRV_CMOS_MODULE
 EXPORT_SYMBOL(rtc_lock);
-#endif
 #endif	/* pc-style 'CMOS' RTC support */
 
 /* change this if you have some constant time drift */
-- 
1.7.5.4

