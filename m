Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0GZJTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:19:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38645 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0GZJT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UB0T5geqBsTovV4EWTpwCqz7LraNFwci9d8zTWVKmGS59OcnD7Avsp2O8PH4/b8Ghz
         wO113LYv+cpudTAFPXxwmJlPRw40OGZjX5+tpe85ThXfyqpU8DESqKQcQjNavS6/eKCL
         9MEq8O9IjjhtlDHFVll+nQNR5wVBNwzaq+nSE=
From: Changli Gao <xiaosuo@gmail.com>
To: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] dlm: use genl_register_family_with_ops()
Date: Mon, 26 Jul 2010 17:19:19 +0800
Message-Id: <1280135959-17485-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/dlm/netlink.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 2c6ad51..ef17e01 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -81,24 +81,11 @@ static struct genl_ops dlm_nl_ops = {
 
 int __init dlm_netlink_init(void)
 {
-	int rv;
-
-	rv = genl_register_family(&family);
-	if (rv)
-		return rv;
-
-	rv = genl_register_ops(&family, &dlm_nl_ops);
-	if (rv < 0)
-		goto err;
-	return 0;
- err:
-	genl_unregister_family(&family);
-	return rv;
+	return genl_register_family_with_ops(&family, &dlm_nl_ops, 1);
 }
 
 void dlm_netlink_exit(void)
 {
-	genl_unregister_ops(&family, &dlm_nl_ops);
 	genl_unregister_family(&family);
 }
 
