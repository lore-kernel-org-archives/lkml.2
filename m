Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1DYUYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:33 -0400
Received: from 1wt.eu ([62.212.114.60]:34091 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab1DYUY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:27 -0400
Message-Id: <20110425200235.298507662@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Matthew Garrett <mjg@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 053/173] platform: x86: asus_acpi: world-writable procfs files
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 8040835760adf0ef66876c063d47f79f015fb55d upstream.

Don't allow everybody to change ACPI settings.  The comment says that it
is done deliberatelly, however, the comment before disp_proc_write()
says that at least one of these setting is experimental.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/asus_acpi.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -1001,14 +1001,8 @@ static int asus_hotk_add_fs(struct acpi_
 	struct proc_dir_entry *proc;
 	mode_t mode;
 
-	/*
-	 * If parameter uid or gid is not changed, keep the default setting for
-	 * our proc entries (-rw-rw-rw-) else, it means we care about security,
-	 * and then set to -rw-rw----
-	 */
-
 	if ((asus_uid == 0) && (asus_gid == 0)) {
-		mode = S_IFREG | S_IRUGO | S_IWUGO;
+		mode = S_IFREG | S_IRUGO | S_IWUSR | S_IWGRP;
 	} else {
 		mode = S_IFREG | S_IRUSR | S_IRGRP | S_IWUSR | S_IWGRP;
 		printk(KERN_WARNING "  asus_uid and asus_gid parameters are "


