Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030330Ab2EKWMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:12:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43195 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030237Ab2EKWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:09:38 -0400
From: mathieu.poirier@linaro.org
To: JBottomley@parallels.com
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH 3/7] drivers/scsi: use correct __devexit_p annotation
Date: Fri, 11 May 2012 16:09:24 -0600
Message-Id: <1336774168-26577-4-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

__devexit functions are discarded when CONFIG_HOTPLUG
is not set, so the symbol needs to be referenced carefully.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/pmcraid.c        |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ea8a0b4..becc472 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -6084,7 +6084,7 @@ static struct pci_driver pmcraid_driver = {
 	.name = PMCRAID_DRIVER_NAME,
 	.id_table = pmcraid_pci_table,
 	.probe = pmcraid_probe,
-	.remove = pmcraid_remove,
+	.remove = __devexit_p(pmcraid_remove),
 	.suspend = pmcraid_suspend,
 	.resume = pmcraid_resume,
 	.shutdown = pmcraid_shutdown
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ee47820..ff7c26f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5982,7 +5982,7 @@ static struct pci_driver qla4xxx_pci_driver = {
 	.name		= DRIVER_NAME,
 	.id_table	= qla4xxx_pci_tbl,
 	.probe		= qla4xxx_probe_adapter,
-	.remove		= qla4xxx_remove_adapter,
+	.remove		= __devexit_p(qla4xxx_remove_adapter),
 	.err_handler = &qla4xxx_err_handler,
 };
 
-- 
1.7.5.4

