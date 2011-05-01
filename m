Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab1EABtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:49:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1EABhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nosexAQBYnj+TrVE1IS4JvyPf2zvIKtq6cSTcFrTg+qORPSwh/0qtUCxGyXgV71D4+
         /ep8dmtZ1YfAHGzjNxBmFwQ6cl1DZWJWvFNqmiJXInKE+bTtt/JTukfPJewN5c6cCU7/
         IFrkrNwoKrz3rpncUJP12kc5M5BztfJTXaBf0=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 35/69] sysctl: remove .child from sunrpc/ (xprtrdma)
Date: Sun,  1 May 2011 03:36:05 +0200
Message-Id: <1304213799-10257-36-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/sunrpc/xprtrdma/transport.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 0867070..9736c93 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -85,7 +85,7 @@ static unsigned int max_memreg = RPCRDMA_LAST - 1;
 
 static struct ctl_table_header *sunrpc_table_header;
 
-static ctl_table xr_tunables_table[] = {
+static ctl_table rdma_table[] = {
 	{
 		.procname	= "rdma_slot_table_entries",
 		.data		= &xprt_rdma_slot_table_entries,
@@ -137,13 +137,9 @@ static ctl_table xr_tunables_table[] = {
 	{ },
 };
 
-static ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= xr_tunables_table
-	},
-	{ },
+static const struct ctl_path sunrpc_path[] = {
+	{ .procname = "sunrpc" },
+	{ }
 };
 
 #endif
@@ -771,7 +767,7 @@ static int __init xprt_rdma_init(void)
 
 #ifdef RPC_DEBUG
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+		sunrpc_table_header = register_sysctl_paths(sunrpc_path, rdma_table);
 #endif
 	return 0;
 }
-- 
1.7.5.134.g1c08b

