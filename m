Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1EABuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:50:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1EABhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CB5vJ7/Xa/dSA586prlLpLteSZEr+iLa7ZUxbOeQ9yFazME5+cBQE1n7NGALgi3T7U
         J5qPUgYcQnrt7zgcBFwvIr2MEc7ruGvOj2t//hZXnTYvyUExaaIfyaOQy95ObBPX0Poo
         g8yvw56RjF+S7bnaYsy5sd0FWQ7Swo9UClj+M=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 28/69] sysctl: remove .child from kernel/ (ipc)
Date: Sun,  1 May 2011 03:35:58 +0200
Message-Id: <1304213799-10257-29-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 ipc/ipc_sysctl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 56410fa..9e408a6 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -194,18 +194,14 @@ static struct ctl_table ipc_kern_table[] = {
 	{}
 };
 
-static struct ctl_table ipc_root_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= ipc_kern_table,
-	},
-	{}
+static const __initdata struct ctl_path ipc_path[] = {
+	{ .procname = "kernel" },
+	{ }
 };
 
 static int __init ipc_sysctl_init(void)
 {
-	register_sysctl_table(ipc_root_table);
+	register_sysctl_paths(ipc_path, ipc_kern_table);
 	return 0;
 }
 
-- 
1.7.5.134.g1c08b

