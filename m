Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab1EABjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab1EABhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qnhEb/5NfT3uuUB6QWFZYWEALZ1brdRgZLmBoPsleT4uUNKHNavCgyGQH3D+E6MnK/
         UdoKBB0SfrOHU/N8xtu7xyR+QqFoWJLvyuXACbfKtxmzjV9lKqsFW5DA+HygdVmmq/Me
         zZvUt8tg3pqPHveCT7SY4QuFMRjbz9XWrgHKU=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 36/69] sysctl: remove .child from sunrpc/ (xprtsock)
Date: Sun,  1 May 2011 03:36:06 +0200
Message-Id: <1304213799-10257-37-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 net/sunrpc/xprtsock.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index bf005d3..610a2fe 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -59,7 +59,7 @@ static unsigned int xs_tcp_fin_timeout __read_mostly = XS_TCP_LINGER_TO;
 
 /*
  * We can register our own files under /proc/sys/sunrpc by
- * calling register_sysctl_table() again.  The files in that
+ * calling register_sysctl_paths() again.  The files in that
  * directory become the union of all files registered there.
  *
  * We simply need to make sure that we don't collide with
@@ -79,7 +79,7 @@ static struct ctl_table_header *sunrpc_table_header;
  * FIXME: changing the UDP slot table size should also resize the UDP
  *        socket buffers for existing UDP transports
  */
-static ctl_table xs_tunables_table[] = {
+static ctl_table xprtsock_table[] = {
 	{
 		.procname	= "udp_slot_table_entries",
 		.data		= &xprt_udp_slot_table_entries,
@@ -126,13 +126,9 @@ static ctl_table xs_tunables_table[] = {
 	{ },
 };
 
-static ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= xs_tunables_table
-	},
-	{ },
+static const struct ctl_path sunrpc_path[] = {
+	{ .procname = "sunrpc" },
+	{ }
 };
 
 #endif
@@ -2470,7 +2466,7 @@ int init_socket_xprt(void)
 {
 #ifdef RPC_DEBUG
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+		sunrpc_table_header = register_sysctl_paths(sunrpc_path, xprtsock_table);
 #endif
 
 	xprt_register_transport(&xs_udp_transport);
-- 
1.7.5.134.g1c08b

