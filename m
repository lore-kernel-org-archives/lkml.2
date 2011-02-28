Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1B1QiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:38:00 -0500
Received: from kroah.org ([198.145.64.141]:48167 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab1B1Qh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:10 2011
Message-Id: <20110228162410.532997578@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [48/68] platform: x86: asus_acpi: world-writable procfs files
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
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


