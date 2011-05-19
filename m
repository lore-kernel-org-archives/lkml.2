Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058Ab1ESXNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:13:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933678Ab1ESXN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:13:26 -0400
Date: Fri, 20 May 2011 02:12:46 +0300
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
Subject: [PATCHv2 14/14] vhost: fix 64 bit features
Message-ID: <4045f98f2b0ab9b1d62468e6b66328c236b89f4d.1305846412.git.mst@redhat.com>
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

Update vhost_has_feature to make it work correctly for bit > 32.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 8e03379..64889d2 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -123,7 +123,7 @@ struct vhost_dev {
 	struct vhost_memory __rcu *memory;
 	struct mm_struct *mm;
 	struct mutex mutex;
-	unsigned acked_features;
+	u64 acked_features;
 	struct vhost_virtqueue *vqs;
 	int nvqs;
 	struct file *log_file;
@@ -176,14 +176,14 @@ enum {
 			 (1ULL << VIRTIO_NET_F_MRG_RXBUF),
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
