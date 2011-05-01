Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab1EABjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:16 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62031 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934Ab1EABho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qXw1jOPMmh/ocX8I/JmmH/SzKj+yFxhbreBBvTPstqnGYN4yl4+LTy4fgmU9dtsCVh
         MNdOClEXFxmiaiV5a7iR6mUkaX8xkt7yTwQi3WWKAC4bRv+/kONLfPfBr35EJmNm89Y7
         vj7Yei2Ro0Ja+hj3STfVSEay5vEKXB09kMyq8=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 39/69] sysctl: remove .child from lasat/ (mips)
Date: Sun,  1 May 2011 03:36:09 +0200
Message-Id: <1304213799-10257-40-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 arch/mips/lasat/sysctl.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/mips/lasat/sysctl.c b/arch/mips/lasat/sysctl.c
index d87ffd0..a6191f0 100644
--- a/arch/mips/lasat/sysctl.c
+++ b/arch/mips/lasat/sysctl.c
@@ -262,21 +262,16 @@ static ctl_table lasat_table[] = {
 	{}
 };
 
-static ctl_table lasat_root_table[] = {
-	{
-		.procname	= "lasat",
-		.mode		=  0555,
-		.child		= lasat_table
-	},
-	{}
+static const __initdata struct ctl_path lasat_path[] = {
+	{ .procname = "lasat" },
+	{ }
 };
 
 static int __init lasat_register_sysctl(void)
 {
 	struct ctl_table_header *lasat_table_header;
 
-	lasat_table_header =
-		register_sysctl_table(lasat_root_table);
+	lasat_table_header = register_sysctl_paths(lasat_path, lasat_table);
 	if (!lasat_table_header) {
 		printk(KERN_ERR "Unable to register LASAT sysctl\n");
 		return -ENOMEM;
-- 
1.7.5.134.g1c08b

