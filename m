Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1JBOsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:48:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab1JBOq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/30] ARM: omap/iommu: always provide iommu debug code
Date: Sun,  2 Oct 2011 16:45:40 +0200
Message-Id: <1317566760-25681-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:dgqfMyzjnOqKnYqHqrW2ZdLFxVXmS+pBGRGnyNew7P1
 lK7GJ6bZCUt6ZPJgCRcjtGTMdEZ3oOPtndb6O2KYZiawCbg7hQ
 qAU4OEl8R7JtdS9Q5DSfrss+tNh7coVk00JklbQlVZXohmza5/
 erIJnLW0W6eFnsYal9T01JvbiS55cz9EEN74C6RqrTb5qZl6kM
 mV0XSk+Q1eM9PIuu0vS2s3Xitg1iNoT0eXSko1EprmJTCrnXb8
 HA1coGg9JhMHZufWGZXjtkrjtkawVSS16f4ahrDPr95xdAc0WL
 7aqhKt/rVBG5NyFx88LXx4XbpJGm7/M+Eo9FX1vcGZ1FoLBhNS
 Z3ljIZ6KHOta1HVlrXQyDyQyBtoRXM7nfx1TJYHiU4w6fVXQrs
 t4LicpvZxQdSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu module on omap contains a few functions that are
only used by the debug module. These are however only there
when the debug code is built as a module. Since it is possible
to build the debug code into the kernel, the functions should
also be provided for the built-in case.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/plat-omap/iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index 34fc31e..9d43ce1 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -391,7 +391,7 @@ void iommu_set_twl(struct iommu *obj, bool on)
 }
 EXPORT_SYMBOL_GPL(iommu_set_twl);
 
-#if defined(CONFIG_OMAP_IOMMU_DEBUG_MODULE)
+#if defined(CONFIG_OMAP_IOMMU_DEBUG) || defined(CONFIG_OMAP_IOMMU_DEBUG_MODULE)
 
 ssize_t iommu_dump_ctx(struct iommu *obj, char *buf, ssize_t bytes)
 {
-- 
1.7.5.4

