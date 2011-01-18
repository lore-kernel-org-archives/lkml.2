Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab1ARLJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 06:09:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1ARLJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 06:09:38 -0500
Date: Tue, 18 Jan 2011 13:08:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: rcu annotation fixup
Message-ID: <20110118110845.GA11555@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When built with rcu checks enabled, vhost triggers
bogus warnings as vhost features are read without
dev->mutex sometimes.
Fixing it properly is not trivial as vhost.h does not
know which lockdep classes it will be used under.
Disable the warning by stubbing out the check for now.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 2af44b7..2d03a31 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -173,9 +173,7 @@ static inline int vhost_has_feature(struct vhost_dev *dev, int bit)
 {
 	unsigned acked_features;
 
-	acked_features =
-		rcu_dereference_index_check(dev->acked_features,
-					    lockdep_is_held(&dev->mutex));
+	acked_features = rcu_dereference_index_check(dev->acked_features, 1);
 	return acked_features & (1 << bit);
 }
 
-- 
1.7.3.2.91.g446ac
