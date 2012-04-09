Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab2DIUvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:51:45 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21165 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2DIUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:51:42 -0400
Date: Mon, 9 Apr 2012 22:51:41 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 19/26] [SCSI] qla2xxx: Remove redundant NULL check before
 release_firmware() call.
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092229370.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() checks for NULL pointers internally so checking
before calling it is redundant.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a2f9992..91b6fe6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4106,8 +4106,7 @@ qla2x00_release_firmware(void)
 
 	mutex_lock(&qla_fw_lock);
 	for (idx = 0; idx < FW_BLOBS; idx++)
-		if (qla_fw_blobs[idx].fw)
-			release_firmware(qla_fw_blobs[idx].fw);
+		release_firmware(qla_fw_blobs[idx].fw);
 	mutex_unlock(&qla_fw_lock);
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

