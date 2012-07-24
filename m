Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2GXPzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:55:40 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53230 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2GXPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:55:39 -0400
From: Vivek Trivedi <vtrivedi018@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin McKinney <klmckinney1@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Vivek Trivedi <vtrivedi018@gmail.com>, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] staging: bcm: use SEEK_SET instead of 0 in vfs_llseek
Date: Tue, 24 Jul 2012 21:25:04 +0530
Message-Id: <1343145304-4555-1-git-send-email-vtrivedi018@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're equivalent, but SEEK_SET seems more informative...

Signed-off-by: Vivek Trivedi <vtrivedi018@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 drivers/staging/bcm/Misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index 8223a69..8fab3ec 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -203,7 +203,7 @@ static int BcmFileDownload(PMINI_ADAPTER Adapter, const char *path, unsigned int
 	}
 	oldfs = get_fs();
 	set_fs(get_ds());
-	vfs_llseek(flp, 0, 0);
+	vfs_llseek(flp, 0, SEEK_SET);
 	set_fs(oldfs);
 	if (Adapter->bcm_file_readback_from_chip(Adapter->pvInterfaceAdapter, flp, loc)) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Failed to read back firmware!");
-- 
1.7.1

