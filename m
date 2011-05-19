Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab1ESXMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:12:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933288Ab1ESXL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:11:57 -0400
Date: Fri, 20 May 2011 02:11:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: [PATCHv2 08/14] virtio_ring: Add capacity check API
Message-ID: <aa74c75c16a71a15599dc68597d975caa66fda6f.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Shirley Ma <mashirle@us.ibm.com>

Signed-off-by: Shirley Ma <xma@us.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c |    8 ++++++++
 include/linux/virtio.h       |    5 +++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 6578e1a..eed5f29 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -344,6 +344,14 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_buf);
 
+int virtqueue_get_capacity(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	return vq->num_free;
+}
+EXPORT_SYMBOL_GPL(virtqueue_get_capacity);
+
 void virtqueue_disable_cb(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 7108857..58c0953 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -42,6 +42,9 @@ struct virtqueue {
  *	vq: the struct virtqueue we're talking about.
  *	len: the length written into the buffer
  *	Returns NULL or the "data" token handed to add_buf.
+ * virtqueue_get_capacity: get the current capacity of the queue
+ *	vq: the struct virtqueue we're talking about.
+ *	Returns remaining capacity of the queue.
  * virtqueue_disable_cb: disable callbacks
  *	vq: the struct virtqueue we're talking about.
  *	Note that this is not necessarily synchronous, hence unreliable and only
@@ -89,6 +92,8 @@ void virtqueue_kick(struct virtqueue *vq);
 
 void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
 
+int virtqueue_get_capacity(struct virtqueue *vq);
+
 void virtqueue_disable_cb(struct virtqueue *vq);
 
 bool virtqueue_enable_cb(struct virtqueue *vq);
-- 
1.7.5.53.gc233e

