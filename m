Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1IZJbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:31:11 -0400
Received: from cernmx32.cern.ch ([137.138.144.178]:57031 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1IZJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:31:08 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 4/4] staging: vme_user: rename USER_BUS_MAX to VME_USER_BUS_MAX
Date: Mon, 26 Sep 2011 11:27:18 +0200
Message-ID: <1317029238-13357-5-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
References: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/devices/vme_user.c |   10 +++++-----
 drivers/staging/vme/devices/vme_user.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 9518dda..7dcd162 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -43,7 +43,7 @@
 static DEFINE_MUTEX(vme_user_mutex);
 static const char driver_name[] = "vme_user";
 
-static int bus[USER_BUS_MAX];
+static int bus[VME_USER_BUS_MAX];
 static unsigned int bus_num;
 
 /* Currently Documentation/devices.txt defines the following for VME:
@@ -643,10 +643,10 @@ static int __init vme_user_init(void)
 	/* Let's start by supporting one bus, we can support more than one
 	 * in future revisions if that ever becomes necessary.
 	 */
-	if (bus_num > USER_BUS_MAX) {
+	if (bus_num > VME_USER_BUS_MAX) {
 		printk(KERN_ERR "%s: Driver only able to handle %d buses\n",
-			driver_name, USER_BUS_MAX);
-		bus_num = USER_BUS_MAX;
+			driver_name, VME_USER_BUS_MAX);
+		bus_num = VME_USER_BUS_MAX;
 	}
 
 	/*
@@ -668,7 +668,7 @@ err_nocard:
 
 static int vme_user_match(struct vme_dev *vdev)
 {
-	if (vdev->num >= USER_BUS_MAX)
+	if (vdev->num >= VME_USER_BUS_MAX)
 		return 0;
 	return 1;
 }
diff --git a/drivers/staging/vme/devices/vme_user.h b/drivers/staging/vme/devices/vme_user.h
index 24bf4e5..d85a1e9 100644
--- a/drivers/staging/vme/devices/vme_user.h
+++ b/drivers/staging/vme/devices/vme_user.h
@@ -1,7 +1,7 @@
 #ifndef _VME_USER_H_
 #define _VME_USER_H_
 
-#define USER_BUS_MAX                  1
+#define VME_USER_BUS_MAX	1
 
 /*
  * VMEbus Master Window Configuration Structure
-- 
1.7.4.1

