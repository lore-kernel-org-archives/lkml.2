Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab1LNLtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:49:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab1LNLt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:49:28 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 2/7] remoteproc: avoid registering a virtio device if not supported
Date: Wed, 14 Dec 2011 13:48:30 +0200
Message-Id: <1323863315-8159-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323863315-8159-1-git-send-email-ohad@wizery.com>
References: <1323863315-8159-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Grosen <mgrosen@ti.com>

Let remoteproc know when the firmware doesn't support any virtio
functionality, so registering a virtio device can be avoided.

This is needed for remote processors that doesn't require any
virtio-based communications, but are still controlled via remoteproc.

[ohad@wizery.com: write commit log]

Signed-off-by: Mark Grosen <mgrosen@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 0d9a955..080c056 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -695,7 +695,7 @@ static int
 rproc_handle_virtio_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
 {
 	struct device *dev = rproc->dev;
-	int ret = 0;
+	int ret = -ENODEV;
 
 	for (; len >= sizeof(*rsc); rsc++, len -= sizeof(*rsc))
 		if (rsc->type == RSC_VIRTIO_DEV) {
-- 
1.7.5.4

