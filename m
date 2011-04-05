Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1DEPBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:44475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab1DEO7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:41 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 32/34] pmcraid: Drop __DATE__ usage
Date: Tue,  5 Apr 2011 16:59:19 +0200
Message-Id: <1302015561-21047-33-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/scsi/pmcraid.c |    9 ++++-----
 drivers/scsi/pmcraid.h |    1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 321cf3a..7c13201 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4249,8 +4249,8 @@ static ssize_t pmcraid_show_drv_version(
 	char *buf
 )
 {
-	return snprintf(buf, PAGE_SIZE, "version: %s, build date: %s\n",
-			PMCRAID_DRIVER_VERSION, PMCRAID_DRIVER_DATE);
+	return snprintf(buf, PAGE_SIZE, "version: %s\n",
+			PMCRAID_DRIVER_VERSION);
 }
 
 static struct device_attribute pmcraid_driver_version_attr = {
@@ -6093,9 +6093,8 @@ static int __init pmcraid_init(void)
 	dev_t dev;
 	int error;
 
-	pmcraid_info("%s Device Driver version: %s %s\n",
-			 PMCRAID_DRIVER_NAME,
-			 PMCRAID_DRIVER_VERSION, PMCRAID_DRIVER_DATE);
+	pmcraid_info("%s Device Driver version: %s\n",
+			 PMCRAID_DRIVER_NAME, PMCRAID_DRIVER_VERSION);
 
 	error = alloc_chrdev_region(&dev, 0,
 				    PMCRAID_MAX_ADAPTERS,
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 4db210d..d302737 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -43,7 +43,6 @@
 #define PMCRAID_DRIVER_NAME		"PMC MaxRAID"
 #define PMCRAID_DEVFILE			"pmcsas"
 #define PMCRAID_DRIVER_VERSION		"1.0.3"
-#define PMCRAID_DRIVER_DATE		__DATE__
 
 #define PMCRAID_FW_VERSION_1		0x002
 
-- 
1.7.4.1

