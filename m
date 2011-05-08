Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1EHW7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:59:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab1EHWlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fYvAZQvk4YwsPhPt7fYaw0ShrAFDjU9XXcJlQ8JNOUqhEnaqA1SvGaKplUY2af73HD
         YN45Me8jZXr6BxgM747ZVsRzl+ceJuslT9JTKl15bBnixdPT7ouVlqvPFnAEbRyvaN36
         3DduCWU42sP4M1NQB9VrlpVuFqOKKDk6UJ4vk=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 033/115] sysctl: remove .child from sunrpc/
Date: Mon,  9 May 2011 00:38:45 +0200
Message-Id: <1304894407-32201-34-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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

