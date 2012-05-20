Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2ETKos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 06:44:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39213 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2ETKoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 06:44:46 -0400
From: Chen Baozi <baozich@gmail.com>
To: rusty@rustcorp.com.au
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Chen Baozi <chenbaozi@gmail.com>
Subject: [PATCH] virtio: fix typo in comment
Date: Sun, 20 May 2012 10:44:34 +0800
Message-Id: <1337481874-3472-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Baozi <chenbaozi@gmail.com>

- Delete "@request_vqs" and "@free_vqs" comments, since
  they are no longer in struct virtio_config_ops.
- According to the macro below, "@val" should be "@v".

Signed-off-by: Chen Baozi <chenbaozi@gmail.com>
---
 include/linux/virtio_config.h |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 7323a33..fc457f4 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -74,15 +74,6 @@
  * @set_status: write the status byte
  *	vdev: the virtio_device
  *	status: the new status byte
- * @request_vqs: request the specified number of virtqueues
- *	vdev: the virtio_device
- *	max_vqs: the max number of virtqueues we want
- *      If supplied, must call before any virtqueues are instantiated.
- *      To modify the max number of virtqueues after request_vqs has been
- *      called, call free_vqs and then request_vqs with a new value.
- * @free_vqs: cleanup resources allocated by request_vqs
- *	vdev: the virtio_device
- *      If supplied, must call after all virtqueues have been deleted.
  * @reset: reset the device
  *	vdev: the virtio device
  *	After this, status and feature negotiation must be done again
@@ -156,7 +147,7 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
  * @vdev: the virtio device
  * @fbit: the feature bit
  * @offset: the type to search for.
- * @val: a pointer to the value to fill in.
+ * @v: a pointer to the value to fill in.
  *
  * The return value is -ENOENT if the feature doesn't exist.  Otherwise
  * the config value is copied into whatever is pointed to by v. */
-- 
1.7.1

