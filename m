Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab1L1XHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:07:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35817 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1L1XH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:07:28 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 2/7 v3] staging: vt6656: iwctl.c: Remove useless function
Date: Wed, 28 Dec 2011 21:07:40 +0000
Message-Id: <1325106460-2548-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The funciton iwctl_commit does nothing, and can be removed.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 In the last patch Dan Carpenter ask me to remove the commented code of this source file.
 This is done by the patch I sent before this.

 drivers/staging/vt6656/iwctl.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 480e07f..0b28d0f 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -85,16 +85,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	return &pDevice->wstats;
 }
 
-static int iwctl_commit(struct net_device *dev,
-			      struct iw_request_info *info,
-			      void *wrq,
-			      char *extra)
-{
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWCOMMIT\n");
-
-	return 0;
-}
-
 /*
  * Wireless Handler : get protocol name
  */
@@ -1818,7 +1808,7 @@ int iwctl_siwmlme(struct net_device *dev,
 
 static const iw_handler		iwctl_handler[] =
 {
-	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
+	(iw_handler) NULL,      /* SIOCSIWCOMMIT */
 	(iw_handler) NULL,      // SIOCGIWNAME
 	(iw_handler) NULL,				// SIOCSIWNWID
 	(iw_handler) NULL,				// SIOCGIWNWID
-- 
1.7.4.4

