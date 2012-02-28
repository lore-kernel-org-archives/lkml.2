Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886Ab2B1RVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:21:43 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53787 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965870Ab2B1RVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:21:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.92.229 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, Mark Grosen <mgrosen@ti.com>,
        Suman Anna <s-anna@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>, Rob Clark <rob@ti.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/5] remoteproc/omap: two Kconfig fixes
Date: Tue, 28 Feb 2012 19:21:09 +0200
Message-Id: <1330449672-18191-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330449672-18191-1-git-send-email-ohad@wizery.com>
References: <1330449672-18191-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Depend on OMAP_IOMMU instead of selecting it, to fix an unmet
   direct dependency of it (and its imminent build error)
2. Set default to 'no' (achieved implicitly by dropping the 'default'
   line)

Reported-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: Suman Anna <s-anna@ti.com>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: Rob Clark <rob@ti.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 drivers/remoteproc/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 25fc4cc..24d880e 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -8,11 +8,10 @@ config REMOTEPROC
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
 	depends on ARCH_OMAP4
-	select OMAP_IOMMU
+	depends on OMAP_IOMMU
 	select REMOTEPROC
 	select OMAP_MBOX_FWK
 	select RPMSG
-	default m
 	help
 	  Say y here to support OMAP's remote processors (dual M3
 	  and DSP on OMAP4) via the remote processor framework.
-- 
1.7.5.4

