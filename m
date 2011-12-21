Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab1LULWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:22:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37959 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab1LULWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:22:13 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Rob Clark <rob@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Subject: [PATCH 1/2] remoteproc: depend on EXPERIMENTAL
Date: Wed, 21 Dec 2011 13:21:12 +0200
Message-Id: <1324466473-5128-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remoteproc is still under development and as it gets traction we
definitely expect to have some changes in the binary format (most probably
only in the resource table, e.g. the upcoming move to TLV-based entries).

Active testing and use of remoteproc is most welcome, but we don't want
users to expect backward binary compatibility with the preliminary
images we have today.

Therefore mark remoteproc as EXPERIMENTAL, and explicitly inform the user
about this when a new remote processor is registered.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Clark <rob@ti.com>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
---
 drivers/remoteproc/Kconfig           |    3 ++-
 drivers/remoteproc/remoteproc_core.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 00fb72f..25fc4cc 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -1,8 +1,9 @@
-menu "Remoteproc drivers"
+menu "Remoteproc drivers (EXPERIMENTAL)"
 
 # REMOTEPROC gets selected by whoever wants it
 config REMOTEPROC
 	tristate
+	depends on EXPERIMENTAL
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index f2354ce..6212b82 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1275,6 +1275,9 @@ int rproc_register(struct rproc *rproc)
 
 	dev_info(rproc->dev, "%s is available\n", rproc->name);
 
+	dev_info(dev, "Note: remoteproc is still under development and considered experimental.\n");
+	dev_info(dev, "THE BINARY FORMAT IS NOT YET FINALIZED, and backward compatibility isn't yet guaranteed.\n");
+
 	/* create debugfs entries */
 	rproc_create_debug_dir(rproc);
 
-- 
1.7.5.4

