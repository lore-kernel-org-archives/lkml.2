Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1EDUvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab1EDUvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:51:52 -0400
Date: Wed, 4 May 2011 23:50:52 +0300
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
Subject: [PATCH 03/18] vhost: fix 64 bit features
Message-ID: <c69b269bd53b79aba852a124e96afdb8e64d1c82.1304541919.git.mst@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1304541918.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update vhost_has_feature to make it work correctly for bit > 32.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b3363ae..0f1bf33 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -117,7 +117,7 @@ struct vhost_dev {
 	struct vhost_memory __rcu *memory;
 	struct mm_struct *mm;
 	struct mutex mutex;
-	unsigned acked_features;
+	u64 acked_features;
 	struct vhost_virtqueue *vqs;
 	int nvqs;
 	struct file *log_file;
@@ -169,14 +169,14 @@ enum {
 			 (1 << VIRTIO_NET_F_MRG_RXBUF),
 };
 
-static inline int vhost_has_feature(struct vhost_dev *dev, int bit)
+static inline bool vhost_has_feature(struct vhost_dev *dev, int bit)
 {
-	unsigned acked_features;
+	u64 acked_features;
 
 	/* TODO: check that we are running from vhost_worker or dev mutex is
 	 * held? */
 	acked_features = rcu_dereference_index_check(dev->acked_features, 1);
-	return acked_features & (1 << bit);
+	return acked_features & (1ull << bit);
 }
 
 #endif
-- 
1.7.5.53.gc233e

