Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab1EABi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1EABhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O7ZcSULkLo4Zhiz7ThZCCnqlp63IhrcxTGtkWwbZI8ysN0Xm0fiZ1NDb8uMoPDOLxT
         08ZyqtID05bo6ueJG39bl32QAiQqcLIdjp7501wf6bAjPRMCXYqchf0SSTYqsDa0JBlj
         KKuRbptWknp2AMOSrLYvve+gC2qsNeNoDgNRg=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 17/69] sysctl: remove .child from kernel/sclp (s390)
Date: Sun,  1 May 2011 03:35:47 +0200
Message-Id: <1304213799-10257-18-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/s390/char/sclp_async.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/char/sclp_async.c b/drivers/s390/char/sclp_async.c
index 7ad30e7..43f8b1e 100644
--- a/drivers/s390/char/sclp_async.c
+++ b/drivers/s390/char/sclp_async.c
@@ -106,14 +106,9 @@ static struct ctl_table callhome_table[] = {
 	{}
 };
 
-static struct ctl_table kern_dir_table[] = {
-	{
-		.procname	= "kernel",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= callhome_table,
-	},
-	{}
+static const __initdata struct ctl_path kern_path[] = {
+	{ .procname = "kernel" },
+	{ }
 };
 
 /*
@@ -175,7 +170,7 @@ static int __init sclp_async_init(void)
 	if (!(sclp_async_register.sclp_receive_mask & EVTYP_ASYNC_MASK))
 		goto out_sclp;
 	rc = -ENOMEM;
-	callhome_sysctl_header = register_sysctl_table(kern_dir_table);
+	callhome_sysctl_header = register_sysctl_paths(kern_path, callhome_table);
 	if (!callhome_sysctl_header)
 		goto out_sclp;
 	request = kzalloc(sizeof(struct sclp_req), GFP_KERNEL);
-- 
1.7.5.134.g1c08b

