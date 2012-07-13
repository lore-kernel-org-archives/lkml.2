Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2GMIzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:55:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab2GMIyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:54:23 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RESEND 4/5] vhost-net: Use VHOST_NET_FEATURES for vhost-net
Date: Fri, 13 Jul 2012 16:55:10 +0800
Message-Id: <1342169711-12386-5-git-send-email-asias@redhat.com>
In-Reply-To: <1342169711-12386-1-git-send-email-asias@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost-net's feature does not deseve the name VHOST_FEATURES. Use
VHOST_NET_FEATURES instead.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Asias He <asias@redhat.com>
---
 drivers/vhost/net.c   |    4 ++--
 drivers/vhost/test.c  |    4 ++--
 drivers/vhost/vhost.h |   12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f82a739..072cbba 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -823,14 +823,14 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return vhost_net_set_backend(n, backend.index, backend.fd);
 	case VHOST_GET_FEATURES:
-		features = VHOST_FEATURES;
+		features = VHOST_NET_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof features))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES:
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
-		if (features & ~VHOST_FEATURES)
+		if (features & ~VHOST_NET_FEATURES)
 			return -EOPNOTSUPP;
 		return vhost_net_set_features(n, features);
 	case VHOST_RESET_OWNER:
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 3de00d9..91d6f06 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -261,14 +261,14 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return vhost_test_run(n, test);
 	case VHOST_GET_FEATURES:
-		features = VHOST_FEATURES;
+		features = VHOST_NET_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof features))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES:
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
-		if (features & ~VHOST_FEATURES)
+		if (features & ~VHOST_NET_FEATURES)
 			return -EOPNOTSUPP;
 		return vhost_test_set_features(n, features);
 	case VHOST_RESET_OWNER:
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index c5c7fb0..cc046a9 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -199,12 +199,12 @@ int vhost_zerocopy_signal_used(struct vhost_virtqueue *vq);
 	} while (0)
 
 enum {
-	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
-			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
-			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
-			 (1ULL << VHOST_F_LOG_ALL) |
-			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
-			 (1ULL << VIRTIO_NET_F_MRG_RXBUF),
+	VHOST_NET_FEATURES =	(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
+				(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
+				(1ULL << VIRTIO_RING_F_EVENT_IDX) |
+				(1ULL << VHOST_F_LOG_ALL) |
+				(1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
+				(1ULL << VIRTIO_NET_F_MRG_RXBUF),
 };
 
 static inline int vhost_has_feature(struct vhost_dev *dev, int bit)
-- 
1.7.10.4

