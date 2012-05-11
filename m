Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2EKWNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:13:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36595 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030244Ab2EKWJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:09:36 -0400
From: mathieu.poirier@linaro.org
To: JBottomley@parallels.com
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH 1/7] scsi: mark SCSI_SRP as experimental
Date: Fri, 11 May 2012 16:09:22 -0600
Message-Id: <1336774168-26577-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
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
index 29684c8..651f905 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1885,8 +1885,9 @@ config SCSI_PM8001
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

