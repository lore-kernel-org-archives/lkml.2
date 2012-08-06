Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab2HFSbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:31:16 -0400
Received: from www17.your-server.de ([213.133.104.17]:47680 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab2HFSbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:31:15 -0400
X-Greylist: delayed 1287 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2012 14:31:15 EDT
Subject: [PATCH] net: Use PTR_RET rather than if(IS_ERR(.. [2]
From: Thomas Meyer <thomas@m3y3r.de>
To: "[netdev@vger.kernel.org, linux-kernel@vger.kernel.org]"@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Mon, 06 Aug 2012 19:51:17 +0200
Message-ID: <1344275477.14513.107.camel@localhost.localdomain>
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/ptr_ret.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -1149,9 +1149,7 @@ static struct net_device *atarilance_dev
 static int __init atarilance_module_init(void)
 {
 	atarilance_dev = atarilance_probe(-1);
-	if (IS_ERR(atarilance_dev))
-		return PTR_ERR(atarilance_dev);
-	return 0;
+	return PTR_RET(atarilance_dev);
 }
 
 static void __exit atarilance_module_exit(void)
diff -u -p a/drivers/net/ethernet/amd/mvme147.c b/drivers/net/ethernet/amd/mvme147.c
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -188,9 +188,7 @@ static struct net_device *dev_mvme147_la
 int __init init_module(void)
 {
 	dev_mvme147_lance = mvme147lance_probe(-1);
-	if (IS_ERR(dev_mvme147_lance))
-		return PTR_ERR(dev_mvme147_lance);
-	return 0;
+	return PTR_RET(dev_mvme147_lance);
 }
 
 void __exit cleanup_module(void)
