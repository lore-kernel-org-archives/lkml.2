Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2H0HZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:25:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56424 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab2H0HZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:25:26 -0400
X-IronPort-AV: E=Sophos;i="4.77,833,1336320000"; 
   d="scan'208";a="5730525"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org (open list:S390)
Subject: [PATCH 5/5] s390:block:fix up ENOIOCTLCMD error handling
Date: Mon, 27 Aug 2012 15:23:16 +0800
Message-Id: <1346052196-32682-6-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:15,
	Serialize complete at 2012/08/27 15:25:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
translated as ENOTTY to user mode.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org (open list:S390)
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/s390/block/dasd_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index cceae70..809a89b 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -501,7 +501,7 @@ int dasd_ioctl(struct block_device *bdev, fmode_t mode,
 		if (base->discipline->ioctl) {
 			rc = base->discipline->ioctl(block, cmd, argp);
 			if (rc == -ENOIOCTLCMD)
-				rc = -EINVAL;
+				rc = -ENOTTY;
 		} else
 			rc = -EINVAL;
 	}
-- 
1.7.12

