Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab0FJPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:20:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab0FJPU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:20:57 -0400
Date: Thu, 10 Jun 2010 18:16:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH for-2.6.35] virtio: return ENOMEM on out of memory
Message-ID: <20100610151611.GA3430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_buf returns ring size on out of memory,
this is not what devices expect.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Please consider this patch for 2.6.35.

 drivers/virtio/virtio_ring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ed845b7..dd35b34 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -119,7 +119,7 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 
 	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
 	if (!desc)
-		return vq->vring.num;
+		return -ENOMEM;
 
 	/* Transfer entries from the sg list into the indirect page */
 	for (i = 0; i < out; i++) {
-- 
1.7.1.12.g42b7f
