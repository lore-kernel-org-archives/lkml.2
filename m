Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab1EHXEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:04:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab1EHWko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FFpSTtzGiPbpdxsJLtNCCMtx3eKdToiEL/7srT1eD+4wj8Hn2CMbMkac0gY6vuBhkm
         ROv8IWfQ2EDp6qRphdM21eW+tWz+hRLfq/zYeLe4nQr4GzuqbMd6f0KJtxS7TBS/26Br
         PXF7wiLChtqNoqo/+965XMlDGgISjkSUiyzus=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 013/115] sysctl: remove .child from dev/mac_hid/
Date: Mon,  9 May 2011 00:38:25 +0200
Message-Id: <1304894407-32201-14-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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

