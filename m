Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab1EHWkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:40:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1EHWkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=psfytCnZpe3bAa9mpioc4rKQcXqSMNbalndU9PZSA29djvMNmRO8ZFkyCF4H7Yb4Em
         joc+8VpDKpLiFr0vkEsIAlIkyLEV4d0KM/BG6+fmQEFJ6czeu+D74YEWJHiPwtX7j5oQ
         9ypaMYNEQWqZoDj6iaAz3WtoEMrjLIhfmt1/U=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 015/115] sysctl: remove .child from xpc/
Date: Mon,  9 May 2011 00:38:27 +0200
Message-Id: <1304894407-32201-16-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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

