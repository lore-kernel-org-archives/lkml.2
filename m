Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2ICNsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:48:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35853 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2ICNst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:48:49 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH] remtoteproc: Export notification id range
Date: Mon,  3 Sep 2012 15:48:25 +0200
Message-Id: <1346680105-4764-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Some of the rproc drivers needs to know the range
of the notification IDs used for notifying the device.
Export a variable in struct rproc holding the
largest allocated notification id.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |    3 +++
 include/linux/remoteproc.h           |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index d5c2dbf..00e1674 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -215,6 +215,9 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 		return ret;
 	}
 
+	/* Store largest notifyid */
+	rproc->max_notifyid = max(rproc->max_notifyid, notifyid);
+
 	dev_dbg(dev, "vring%d: va %p dma %x size %x idr %d\n", i, va,
 					dma, size, notifyid);
 
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 131b539..c37e359 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -382,6 +382,7 @@ enum rproc_state {
  * @bootaddr: address of first instruction to boot rproc with (optional)
  * @rvdevs: list of remote virtio devices
  * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
+ * @max_notifyid: Largest allocated notify id.
  * @index: index of this rproc device
  */
 struct rproc {
@@ -406,6 +407,7 @@ struct rproc {
 	struct list_head rvdevs;
 	struct idr notifyids;
 	int index;
+	int max_notifyid;
 };
 
 /* we currently support only two vrings per rvdev */
-- 
1.7.5.4

