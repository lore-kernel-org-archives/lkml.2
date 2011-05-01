Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1EABiB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1EABhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GQtP6Q3FK3chKApcV2a7TKJ8icz7F4RcDWs8ZzQ2m1Ulbd0qyeELB8FT1kvDrPW/uv
         qyAJ6TQipocJqwMeLrLWcD2XuqpVdpBQI85bb0AvmF6aoK0xvd5HOwxnzawIT6ipnWmu
         Q76OBAJJtXJceRY+4bWAPU0+moMhftj2b52oA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 11/69] sysctl: remove .child from dev/ipmi/
Date: Sun,  1 May 2011 03:35:41 +0200
Message-Id: <1304213799-10257-12-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
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

