Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0GZJU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:20:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42794 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0GZJUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EJzVvUI4CNNxNbQaDeplNlwjHMSgq6fC0syJGf8or61ELszTbwYwu0/WOzksOcCZjt
         /AcSMQZf0jPyQmkVC3O35savxvXXwqy7Id/dB3z0intzpR+XNZJag57ljoJIj89PmIjU
         J8gLQkBBsH1MczLfm97aJwBQ1ZZC2vJWegatE=
From: Changli Gao <xiaosuo@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] drop_monitor: use genl_register_family_with_ops()
Date: Mon, 26 Jul 2010 17:20:17 +0800
Message-Id: <1280136017-17526-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 net/core/drop_monitor.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 646ef3b..bdb0e96 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -357,21 +357,12 @@ static int __init init_net_drop_monitor(void)
 		return -ENOSPC;
 	}
 
-	if (genl_register_family(&net_drop_monitor_family) < 0) {
+	rc = genl_register_family_with_ops(&net_drop_monitor_family,
+					   dropmon_ops,
+					   ARRAY_SIZE(dropmon_ops));
+	if (rc) {
 		printk(KERN_ERR "Could not create drop monitor netlink family\n");
-		return -EFAULT;
-	}
-
-	rc = -EFAULT;
-
-	for (i = 0; i < ARRAY_SIZE(dropmon_ops); i++) {
-		ret = genl_register_ops(&net_drop_monitor_family,
-					&dropmon_ops[i]);
-		if (ret) {
-			printk(KERN_CRIT "Failed to register operation %d\n",
-				dropmon_ops[i].cmd);
-			goto out_unreg;
-		}
+		return rc;
 	}
 
 	rc = register_netdevice_notifier(&dropmon_net_notifier);
