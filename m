Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1LTDHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:07:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59602 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab1LTDHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:07:04 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 2/2] staging: vt6656: Remove useless function
Date: Tue, 20 Dec 2011 01:07:27 +0000
Message-Id: <1324343247-28671-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a useless function, because its just return a 0
value.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/iwctl.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 2121205..9dc5757 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -100,21 +100,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	return &pDevice->wstats;
 }
 
-
-
-/*------------------------------------------------------------------*/
-
-
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
@@ -1936,7 +1921,6 @@ int iwctl_siwmlme(struct net_device *dev,
 /*
 static const iw_handler		iwctl_handler[] =
 {
-	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
 	(iw_handler) iwctl_giwname,     // SIOCGIWNAME
 	(iw_handler) NULL,				// SIOCSIWNWID
 	(iw_handler) NULL,				// SIOCGIWNWID
@@ -1998,7 +1982,7 @@ static const iw_handler		iwctl_handler[] =
 
 static const iw_handler		iwctl_handler[] =
 {
-	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
+	(iw_handler) 0,      /* SIOCSIWCOMMIT */
 	(iw_handler) NULL,      // SIOCGIWNAME
 	(iw_handler) NULL,				// SIOCSIWNWID
 	(iw_handler) NULL,				// SIOCGIWNWID
-- 
1.7.4.4

