Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1HNOxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 10:53:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47164 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1HNOxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 10:53:19 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Amit Shah <amit.shah@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 2/3] virtio_config: Add virtio_config_val_len()
Date: Sun, 14 Aug 2011 17:52:32 +0300
Message-Id: <1313333553-23086-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313333553-23086-1-git-send-email-levinsasha928@gmail.com>
References: <1313333553-23086-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds virtio_config_val_len() which allows retrieving variable
length data from the virtio config space only if a specific feature is on.

Cc: Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/virtio_config.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 39c88c5..add4790 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -155,6 +155,9 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 #define virtio_config_val(vdev, fbit, offset, v) \
 	virtio_config_buf((vdev), (fbit), (offset), (v), sizeof(*v))
 
+#define virtio_config_val_len(vdev, fbit, offset, v, len) \
+	virtio_config_buf((vdev), (fbit), (offset), (v), (len))
+
 static inline int virtio_config_buf(struct virtio_device *vdev,
 				    unsigned int fbit,
 				    unsigned int offset,
-- 
1.7.6

