Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab1EABiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1EABh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=w7JZIkfs9/ME/QaPER3HaCbxxj8VcPI3UnzVfnioy02MXBWCoFN3tjd1HRppCTYbwh
         jQA5FFHLcGpnyxf1IpR5TS0og8mURUuqSwwvMOOrLL5v6E0cyDwrJXZfpBKvO9NgSgsI
         mesbPBeFn9Aiy3+WhHw+EE/XlAVfJt7fHwstk=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 23/69] sysctl: remove .child from fs/nfs/ nfs_cb_table
Date: Sun,  1 May 2011 03:35:53 +0200
Message-Id: <1304213799-10257-24-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/nfs/sysctl.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index 978aaeb..046fe19 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -21,7 +21,7 @@ static const int nfs_set_port_max = 65535;
 #endif
 static struct ctl_table_header *nfs_callback_sysctl_table;
 
-static ctl_table nfs_cb_sysctls[] = {
+static ctl_table nfs_cb_table[] = {
 #ifdef CONFIG_NFS_V4
 	{
 		.procname = "nfs_callback_tcpport",
@@ -59,27 +59,15 @@ static ctl_table nfs_cb_sysctls[] = {
 	{ }
 };
 
-static ctl_table nfs_cb_sysctl_dir[] = {
-	{
-		.procname = "nfs",
-		.mode = 0555,
-		.child = nfs_cb_sysctls,
-	},
-	{ }
-};
-
-static ctl_table nfs_cb_sysctl_root[] = {
-	{
-		.procname = "fs",
-		.mode = 0555,
-		.child = nfs_cb_sysctl_dir,
-	},
+static const __initdata struct ctl_path nfs_cb_path[] = {
+	{ .procname = "fs" },
+	{ .procname = "nfs" },
 	{ }
 };
 
 int nfs_register_sysctl(void)
 {
-	nfs_callback_sysctl_table = register_sysctl_table(nfs_cb_sysctl_root);
+	nfs_callback_sysctl_table = register_sysctl_paths(nfs_cb_path, nfs_cb_table);
 	if (nfs_callback_sysctl_table == NULL)
 		return -ENOMEM;
 	return 0;
-- 
1.7.5.134.g1c08b

