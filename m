Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2EMUO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:14:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53999 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2EMUOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:14:55 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Subramaniam Chanderashekarapuram <subramaniam.ca@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] remoteproc: fix off-by-one bug in __rproc_free_vrings
Date: Sun, 13 May 2012 23:14:36 +0300
Message-Id: <1336940076-6317-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subramaniam Chanderashekarapuram <subramaniam.ca@ti.com>

Fix a nasty off-by-one bug in __rproc_free_vrings which
resulted in a memory leak and (for some platforms) failures
to reload the remote processor.

Signed-off-by: Subramaniam Chanderashekarapuram <subramaniam.ca@ti.com>
[ohad@wizery.com: reword commit log, stick with the for loop]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index ee15c68..e756a0d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -354,7 +354,7 @@ static void __rproc_free_vrings(struct rproc_vdev *rvdev, int i)
 {
 	struct rproc *rproc = rvdev->rproc;
 
-	for (i--; i > 0; i--) {
+	for (i--; i >= 0; i--) {
 		struct rproc_vring *rvring = &rvdev->vring[i];
 		int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 
-- 
1.7.5.4

