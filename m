Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0ESPvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0ESPvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:51:01 -0400
From: Jes.Sorensen@redhat.com
To: rusty@rustcorp.com.au
Cc: mst@redhat.com, linux-kernel@vger.kernel.org,
       Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH] virtio_blk.c: Add documentation for vring_enable_cb()
Date: Wed, 19 May 2010 17:50:49 +0200
Message-Id: <1274284249-29398-2-git-send-email-Jes.Sorensen@redhat.com>
In-Reply-To: <1274284249-29398-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1274284249-29398-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Add documentation for vring_enable_cb() as return logic may not be
obvious for the caller.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/virtio/virtio_ring.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 0f90634..2cdcdca 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -333,6 +333,11 @@ static void vring_disable_cb(struct virtqueue *_vq)
 	vq->vring.avail->flags |= VRING_AVAIL_F_NO_INTERRUPT;
 }
 
+/*
+ * Enable interrupts and check whether there is anything in the queue.
+ * Note, vring_enable_cb() returns TRUE if the queue is empty,  and
+ * FALSE if the queue is not empty and there is work to do.
+ */
 static bool vring_enable_cb(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-- 
1.6.5.2

