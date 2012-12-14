Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2LNQHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:07:32 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53643 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab2LNQH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:27 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 03/11] remoteproc: Set vring addresses in resource table
Date: Fri, 14 Dec 2012 17:06:52 +0100
Message-Id: <1355501220-4572-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the vring addresses in the resource table so that
the remote device can read the actual addresses used.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |    5 +++++
 include/linux/remoteproc.h           |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 7d593a1..151e138 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -238,6 +238,8 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	rvring->dma = dma;
 	rvring->notifyid = notifyid;
 
+	rvdev->rsc->vring[i].da = dma;
+	rvdev->rsc->vring[i].notifyid = notifyid;
 	return 0;
 }
 
@@ -365,6 +367,9 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* remember the device features */
 	rvdev->dfeatures = rsc->dfeatures;
 
+	/* remember the resource entry */
+	rvdev->rsc = rsc;
+
 	list_add_tail(&rvdev->node, &rproc->rvdevs);
 
 	/* it is now safe to add the virtio device */
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index faf3332..cdacd66 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -464,6 +464,7 @@ struct rproc_vring {
  * @vring: the vrings for this vdev
  * @dfeatures: virtio device features
  * @gfeatures: virtio guest features
+ * @rsc: vdev resource entry
  */
 struct rproc_vdev {
 	struct list_head node;
@@ -472,6 +473,7 @@ struct rproc_vdev {
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
 	unsigned long dfeatures;
 	unsigned long gfeatures;
+	struct fw_rsc_vdev *rsc;
 };
 
 struct rproc *rproc_alloc(struct device *dev, const char *name,
-- 
1.7.5.4

