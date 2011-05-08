Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1EHWlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:41:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab1EHWlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SxB18v62kP2QoAauZrQGjB32QVjHvxplConrILvMZMuZfPvuPopykUEU+Qf73Uefa5
         SrYbRt2xpu2m8Z8Xz0Z5StDl/Lj3Ui4wqTl7qehomLDazhD4nUJNPOGX3F6B9ws2Z8qH
         Gtc7QYl3+CeV3k/7+vm9h0nWGU71Zp0ueVyNg=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 039/115] sysctl: remove .child from lasat/ (mips)
Date: Mon,  9 May 2011 00:38:51 +0200
Message-Id: <1304894407-32201-40-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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

