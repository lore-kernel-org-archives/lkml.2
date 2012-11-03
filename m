Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2KCWDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:03:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48038 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2KCWC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 9/9] Avoid 'statement with no effect' compiler warnings
Date: Sat,  3 Nov 2012 23:02:30 +0100
Message-Id: <1351980150-24145-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of issuing (0) statements when !CONFIG_SYSFS which will cause
'warning: ', we'll use inline statements instead. This will effectively
do the same thing, but suppress any unnecessary warnings.

Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 net/bridge/br_private.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 9b278c4..af5f584 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -566,10 +566,10 @@ extern void br_sysfs_delbr(struct net_device *dev);
 
 #else
 
-#define br_sysfs_addif(p)	(0)
-#define br_sysfs_renameif(p)	(0)
-#define br_sysfs_addbr(dev)	(0)
-#define br_sysfs_delbr(dev)	do { } while(0)
+static inline int br_sysfs_addif(struct net_bridge_port *p) { return 0; }
+static inline int br_sysfs_renameif(struct net_bridge_port *p) { return 0; }
+static inline int br_sysfs_addbr(struct net_device *dev) { return 0; }
+static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 #endif /* CONFIG_SYSFS */
 
 #endif
-- 
1.7.9.5

