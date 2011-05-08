Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab1EHW7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:59:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab1EHWlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pg21uQ3n47pK+i9ISKbPB5lcK2YOVpfcrcKX2Ew6xOTYJnxMAKvquqaCdubb0V3Wz2
         DHoHuDaQbY5RCFBGS73jfiZIWF4R85RCZ9lJkcDoqKArJEwKP9Ewixi7sFl82ZtCG6Sh
         4zezwcNzSQEc+3Ht0MXBAZ1MjpPEwInAu9JvM=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 034/115] sysctl: remove .child from sunrpc/svc_rdma
Date: Mon,  9 May 2011 00:38:46 +0200
Message-Id: <1304894407-32201-35-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/sunrpc/xprtrdma/svc_rdma.c |   26 +++++++-------------------
 1 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index 09af4fa..d7c0a70 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -118,7 +118,7 @@ static int read_reset_stat(ctl_table *table, int write,
 }
 
 static struct ctl_table_header *svcrdma_table_header;
-static ctl_table svcrdma_parm_table[] = {
+static ctl_table svcrdma_table[] = {
 	{
 		.procname	= "max_requests",
 		.data		= &svcrdma_max_requests,
@@ -213,22 +213,10 @@ static ctl_table svcrdma_parm_table[] = {
 	{ },
 };
 
-static ctl_table svcrdma_table[] = {
-	{
-		.procname	= "svc_rdma",
-		.mode		= 0555,
-		.child		= svcrdma_parm_table
-	},
-	{ },
-};
-
-static ctl_table svcrdma_root_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= svcrdma_table
-	},
-	{ },
+static const struct ctl_path svcrdma_path[] = {
+	{ .procname = "sunrpc" },
+	{ .procname = "svc_rdma" },
+	{ }
 };
 
 void svc_rdma_cleanup(void)
@@ -258,8 +246,8 @@ int svc_rdma_init(void)
 		return -ENOMEM;
 
 	if (!svcrdma_table_header)
-		svcrdma_table_header =
-			register_sysctl_table(svcrdma_root_table);
+		svcrdma_table_header = register_sysctl_paths(
+			svcrdma_path, svcrdma_table);
 
 	/* Create the temporary map cache */
 	svc_rdma_map_cachep = kmem_cache_create("svc_rdma_map_cache",
-- 
1.7.5.134.g1c08b

