Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1FBPnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:43:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab1FBPnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:43:53 -0400
Date: Thu, 2 Jun 2011 18:43:25 +0300
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
Subject: [PATCHv2 RFC 4/4] Revert "virtio: make add_buf return capacity
 remaining:
Message-ID: <7572d6fb81181e349af4a8b203ea0977f6e91ae1.1307029009.git.mst@redhat.com>
References: <cover.1307029008.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307029008.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3c1b27d5043086a485f8526353ae9fe37bfa1065.
The only user was virtio_net, and it switched to
min_capacity instead.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c |    2 +-
 include/linux/virtio.h       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 23422f1..a6c21eb 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -233,7 +233,7 @@ add_head:
 	pr_debug("Added buffer head %i to %p\n", head, vq);
 	END_USE(vq);
 
-	return vq->num_free;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_buf_gfp);
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 209220d..63c4908 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -34,7 +34,7 @@ struct virtqueue {
  *	in_num: the number of sg which are writable (after readable ones)
  *	data: the token identifying the buffer.
  *	gfp: how to do memory allocations (if necessary).
- *      Returns remaining capacity of queue (sg segments) or a negative error.
+ *      Returns 0 on success or a negative error.
  * virtqueue_kick: update after add_buf
  *	vq: the struct virtqueue
  *	After one or more add_buf calls, invoke this to kick the other side.
-- 
1.7.5.53.gc233e
