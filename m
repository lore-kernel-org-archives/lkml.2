Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab1EHXE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:04:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1EHWkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wdow3XccgL3dikdSJHVAl5/c9s0MHYfy1cWCzAxHAUKZfEqL8x7QSgATFdQVc1yIlI
         k4W+T4pFdeAal0afzMD0FBjjzJGmoZ6xc+6Wxzj6Wvz03qNftTvK5tneSCajkTCmfzNR
         CbkEAsDRPwk/QEbT7bS5TjIbbuzuUYgI8F9f0=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 011/115] sysctl: remove .child from dev/ipmi/
Date: Mon,  9 May 2011 00:38:23 +0200
Message-Id: <1304894407-32201-12-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/char/ipmi/ipmi_poweroff.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index 2efa176..ac71d69 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -668,17 +668,9 @@ static ctl_table ipmi_table[] = {
 	{ }
 };
 
-static ctl_table ipmi_dir_table[] = {
-	{ .procname	= "ipmi",
-	  .mode		= 0555,
-	  .child	= ipmi_table },
-	{ }
-};
-
-static ctl_table ipmi_root_table[] = {
-	{ .procname	= "dev",
-	  .mode		= 0555,
-	  .child	= ipmi_dir_table },
+static const struct ctl_path ipmi_path[] = {
+	{ .procname = "dev" },
+	{ .procname = "ipmi" },
 	{ }
 };
 
@@ -699,7 +691,7 @@ static int __init ipmi_poweroff_init(void)
 		printk(KERN_INFO PFX "Power cycle is enabled.\n");
 
 #ifdef CONFIG_PROC_FS
-	ipmi_table_header = register_sysctl_table(ipmi_root_table);
+	ipmi_table_header = register_sysctl_paths(ipmi_path, ipmi_table);
 	if (!ipmi_table_header) {
 		printk(KERN_ERR PFX "Unable to register powercycle sysctl\n");
 		rv = -ENOMEM;
-- 
1.7.5.134.g1c08b

