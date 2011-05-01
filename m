Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab1EABiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:38:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1EABhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mK6lKcqaxj6+Ws3mrwtvCMtOLxIrh3GLewnB4a1wHahIQjQ5SQRbyDLPr7ViD7rra5
         /JiylPQhZWqL/yKuxZjcE9YPfJkF2B+Vx2TFPwSQJTGlPA+HXcTdrPSJlZ4zGh7seVLq
         wPis4BITQ8VeUeIMCmwAL7CAwMFPrtonQnOgI=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 13/69] sysctl: remove .child from dev/mac_hid/
Date: Sun,  1 May 2011 03:35:43 +0200
Message-Id: <1304213799-10257-14-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/macintosh/mac_hid.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index 6a82388..5eec7b7 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -214,7 +214,7 @@ static int mac_hid_toggle_emumouse(ctl_table *table, int write,
 }
 
 /* file(s) in /proc/sys/dev/mac_hid */
-static ctl_table mac_hid_files[] = {
+static ctl_table mac_hid_table[] = {
 	{
 		.procname	= "mouse_button_emulation",
 		.data		= &mouse_emulate_buttons,
@@ -239,25 +239,9 @@ static ctl_table mac_hid_files[] = {
 	{ }
 };
 
-/* dir in /proc/sys/dev */
-static ctl_table mac_hid_dir[] = {
-	{
-		.procname	= "mac_hid",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= mac_hid_files,
-	},
-	{ }
-};
-
-/* /proc/sys/dev itself, in case that is not there yet */
-static ctl_table mac_hid_root_dir[] = {
-	{
-		.procname	= "dev",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= mac_hid_dir,
-	},
+static const __initdata struct ctl_path mac_hid_path[] = {
+	{ .procname = "dev" },
+	{ .procname = "mac_hid" },
 	{ }
 };
 
@@ -265,7 +249,7 @@ static struct ctl_table_header *mac_hid_sysctl_header;
 
 static int __init mac_hid_init(void)
 {
-	mac_hid_sysctl_header = register_sysctl_table(mac_hid_root_dir);
+	mac_hid_sysctl_header = register_sysctl_paths(mac_hid_path, mac_hid_table);
 	if (!mac_hid_sysctl_header)
 		return -ENOMEM;
 
-- 
1.7.5.134.g1c08b

