Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab1C3VIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:61735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933547Ab1C3VIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237483"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: segoon@openwall.com, mjg@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [137/275] platform: x86: asus_acpi: world-writable procfs files
Message-Id: <20110330210617.EDFD13E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit 8040835760adf0ef66876c063d47f79f015fb55d upstream.

Don't allow everybody to change ACPI settings.  The comment says that it
is done deliberatelly, however, the comment before disp_proc_write()
says that at least one of these setting is experimental.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/asus_acpi.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux-2.6.35.y/drivers/platform/x86/asus_acpi.c
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/asus_acpi.c	2011-03-29 22:51:12.619400270 -0700
+++ linux-2.6.35.y/drivers/platform/x86/asus_acpi.c	2011-03-29 23:03:01.117271582 -0700
@@ -1079,14 +1079,8 @@
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
