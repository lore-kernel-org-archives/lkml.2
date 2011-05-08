Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1EHWlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:41:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab1EHWlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Sm7gUS9zyvsq/LBM3+0kZsBE0FsJWrL07WJ9Fcg2VFHWtGI4NUBJjRu3BCQkoMHFdE
         OJ8Bsf9p0A6RY9slMe1cdxhCT5StrwzyY3fuRWmUioPpWxybljnyFqFUaOCVrCo9CuMM
         6IviCkaMipzfKjn8Kb1OY94lfDU93Ybb12qcc=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 035/115] sysctl: remove .child from sunrpc/ (xprtrdma)
Date: Mon,  9 May 2011 00:38:47 +0200
Message-Id: <1304894407-32201-36-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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

