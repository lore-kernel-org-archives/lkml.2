Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1GNQJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:09:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab1GNQJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:09:53 -0400
Date: Thu, 14 Jul 2011 12:09:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
Message-Id: <5aadca57951c420c2713f086401bb6d6188f1ff8.1310657068.git.jbaron@redhat.com>
In-Reply-To: <cover.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
Subject: [PATCH 08/11] dynamic_debug: make netif_dbg() call __netdev_printk()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Previously, netif_dbg() was using dynamic_dev_dbg() to perform
the underlying printk. Fix it to use __netdev_printk(), instead.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/netdevice.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9b132ef..cb73e77 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2732,9 +2732,7 @@ do {								\
 #define netif_dbg(priv, type, netdev, format, args...)		\
 do {								\
 	if (netif_msg_##type(priv))				\
-		dynamic_dev_dbg((netdev)->dev.parent,		\
-				"%s: " format,			\
-				netdev_name(netdev), ##args);	\
+		dynamic_netdev_dbg(netdev, format, ##args);	\
 } while (0)
 #else
 #define netif_dbg(priv, type, dev, format, args...)			\
-- 
1.7.5.4

