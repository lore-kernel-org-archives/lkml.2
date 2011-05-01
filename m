Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab1EABi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49864 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab1EABhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZbAOpEciYNVp9RnJ6wnwLRSN3iBHM+l5/9ixVx5Q706DZpTCdHlDJ5soUeG6dY/dv4
         cfqHQ2Zy3zoGLr/gMCyDjA0F3fj/iF2A1afJHuLthPrWL3B6seqbpzxYBXS596vaEeLb
         VcCjiSTQ7v66vBiaJ4cmEpRITBq5Cyb+FYdjA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 15/69] sysctl: remove .child from xpc/
Date: Sun,  1 May 2011 03:35:45 +0200
Message-Id: <1304213799-10257-16-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/misc/sgi-xp/xpc_main.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 8d082b4..642efb1 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -122,13 +122,11 @@ static ctl_table xpc_sys_xpc_dir[] = {
 	 .extra2 = &xpc_disengage_max_timelimit},
 	{}
 };
-static ctl_table xpc_sys_dir[] = {
-	{
-	 .procname = "xpc",
-	 .mode = 0555,
-	 .child = xpc_sys_xpc_dir},
-	{}
+static const __initdata struct ctl_path xpc_path[] = {
+	{ .procname = "xpc" },
+	{ }
 };
+
 static struct ctl_table_header *xpc_sysctl;
 
 /* non-zero if any remote partition disengage was timed out */
@@ -1236,7 +1234,7 @@ xpc_init(void)
 		goto out_1;
 	}
 
-	xpc_sysctl = register_sysctl_table(xpc_sys_dir);
+	xpc_sysctl = register_sysctl_paths(xpc_path, xpc_sys_xpc_dir);
 
 	/*
 	 * Fill the partition reserved page with the information needed by
-- 
1.7.5.134.g1c08b

