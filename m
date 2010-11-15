Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab0KOVMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:12:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1401 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758576Ab0KOVMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:12:50 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] net/atm: Remove unnecessary casts of netdev_priv
Date: Mon, 15 Nov 2010 13:12:33 -0800
Message-Id: <0953cd1e1042f41ae839f5b9e4adaffd555c71eb.1289855436.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289855436.git.joe@perches.com>
References: <cover.1289855436.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/atm/br2684.c |    2 +-
 net/atm/lec.c    |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index ad2b232..fce2eae 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -97,7 +97,7 @@ static LIST_HEAD(br2684_devs);
 
 static inline struct br2684_dev *BRPRIV(const struct net_device *net_dev)
 {
-	return (struct br2684_dev *)netdev_priv(net_dev);
+	return netdev_priv(net_dev);
 }
 
 static inline struct net_device *list_entry_brdev(const struct list_head *le)
diff --git a/net/atm/lec.c b/net/atm/lec.c
index 181d70c..179e04b 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -816,8 +816,7 @@ static int lec_mcast_attach(struct atm_vcc *vcc, int arg)
 	if (arg < 0 || arg >= MAX_LEC_ITF || !dev_lec[arg])
 		return -EINVAL;
 	vcc->proto_data = dev_lec[arg];
-	return lec_mcast_make((struct lec_priv *)netdev_priv(dev_lec[arg]),
-				vcc);
+	return lec_mcast_make(netdev_priv(dev_lec[arg]), vcc);
 }
 
 /* Initialize device. */
-- 
1.7.3.1.g432b3.dirty

