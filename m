Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1EABtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:49:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab1EABhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z6ZLHahWY2aufgVg4T9MiI6H9+0FBrOx15YfJOp9luII5fmECIV2lSk7FAhg1cgT0I
         1jhbCm31A1xbbhwmYwE3QXguKUxRkYh94/3FVgt3qc/FrA/aG141eFhaIgJK6qA2QoQ7
         8W02+SECgbEa92BS70FWZ7LK2VRbm2UgExQMA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 33/69] sysctl: remove .child from sunrpc/
Date: Sun,  1 May 2011 03:36:03 +0200
Message-Id: <1304213799-10257-34-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/sunrpc/sysctl.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index e65dcc6..7450ab2 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -38,13 +38,17 @@ EXPORT_SYMBOL_GPL(nlm_debug);
 #ifdef RPC_DEBUG
 
 static struct ctl_table_header *sunrpc_table_header;
-static ctl_table		sunrpc_table[];
+static ctl_table sunrpc_table[];
+static const struct ctl_path sunrpc_path[] = {
+	{ .procname = "sunrpc" },
+	{ }
+};
 
 void
 rpc_register_sysctl(void)
 {
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+		sunrpc_table_header = register_sysctl_paths(sunrpc_path, sunrpc_table);
 }
 
 void
@@ -133,7 +137,7 @@ done:
 }
 
 
-static ctl_table debug_table[] = {
+static ctl_table sunrpc_table[] = {
 	{
 		.procname	= "rpc_debug",
 		.data		= &rpc_debug,
@@ -171,13 +175,4 @@ static ctl_table debug_table[] = {
 	{ }
 };
 
-static ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= debug_table
-	},
-	{ }
-};
-
 #endif
-- 
1.7.5.134.g1c08b

