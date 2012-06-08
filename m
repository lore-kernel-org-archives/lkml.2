Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562Ab2FHVzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:55:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59500 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760172Ab2FHVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:53:44 -0400
From: mathieu.poirier@linaro.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH RESEND 1/7] scsi: mark SCSI_SRP as experimental
Date: Fri,  8 Jun 2012 15:53:30 -0600
Message-Id: <1339192416-27026-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
References: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

SCSI_SRP selects SCSI_TGT which is experimental and therefore
must be marked experimental.  Otherwise Kconfig warns about
symbols selecting other symbols that have unsatisfied
dependencies.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e955978..ec8cc9a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1803,8 +1803,9 @@ config SCSI_PM8001
 	  based host adapters.
 
 config SCSI_SRP
-	tristate "SCSI RDMA Protocol helper library"
+	tristate "SCSI RDMA Protocol helper library (EXPERIMENTAL)"
 	depends on SCSI && PCI
+	depends on EXPERIMENTAL
 	select SCSI_TGT
 	help
 	  If you wish to use SRP target drivers, say Y.
-- 
1.7.5.4

