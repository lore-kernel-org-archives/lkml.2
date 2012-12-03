Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab2LCTc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:32:59 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:55686 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2LCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:32:59 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFIiS0PG3rw
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, jbeulich@suse.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] xen/blkback: do not leak mode property
Date: Mon,  3 Dec 2012 20:32:48 +0100
Message-Id: <1354563168-6609-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

be->mode is obtained from xenbus_read, which does a kmalloc for the
message body. The short string is never released, so do it on blkbk
remove.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---

!! Not compile tested !!

 drivers/block/xen-blkback/xenbus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index f58434c..a6585a4 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -366,6 +366,7 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
 		be->blkif = NULL;
 	}
 
+	kfree(be->mode);
 	kfree(be);
 	dev_set_drvdata(&dev->dev, NULL);
 	return 0;
-- 
1.8.0.1

