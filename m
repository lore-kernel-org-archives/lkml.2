Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0GZJVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:21:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63953 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0GZJVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MWVV0oJQgd85T8RBsR0cHjAIOu3BTQTkKch+XrPvRsPe4DoyphhxyvpZjkcZOPJOXx
         guMmgWAQzT4Qs2ar1qfXmF6JLlJU2nTykLawRhyfifroiL2fkLuaMGDr9v6GyYa6GsRc
         Steky+TN2o+rRGFvrRi7C8uHV6Gnhj6Z7uzi0=
From: Changli Gao <xiaosuo@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] genetlink: use genl_register_family_with_ops()
Date: Mon, 26 Jul 2010 17:21:05 +0800
Message-Id: <1280136065-17566-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 net/netlink/genetlink.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index aa4308a..2a2bcc8 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -873,11 +873,7 @@ static int __init genl_init(void)
 	for (i = 0; i < GENL_FAM_TAB_SIZE; i++)
 		INIT_LIST_HEAD(&family_ht[i]);
 
-	err = genl_register_family(&genl_ctrl);
-	if (err < 0)
-		goto problem;
-
-	err = genl_register_ops(&genl_ctrl, &genl_ctrl_ops);
+	err = genl_register_family_with_ops(&genl_ctrl, &genl_ctrl_ops, 1);
 	if (err < 0)
 		goto problem;
 
