Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0LLX7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:59:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36556 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab0LLXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:53 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: davej@redhat.com, len.brown@intel.com, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [167/223] ACPI: debugfs custom_method open to non-root
Message-Id: <20101212234751.76302B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dave Jones <davej@redhat.com>

commit ed3aada1bf34c5a9e98af167f125f8a740fc726a upstream.

Currently we have:

  --w--w--w-. 1 root root 0 2010-11-11 14:56 /sys/kernel/debug/acpi/custom_method

which is just crazy. Change this to --w-------.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/acpi/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/acpi/debug.c
===================================================================
--- linux.orig/drivers/acpi/debug.c
+++ linux/drivers/acpi/debug.c
@@ -258,7 +258,7 @@ static int acpi_debugfs_init(void)
 	if (!acpi_dir)
 		goto err;
 
-	cm_dentry = debugfs_create_file("custom_method", S_IWUGO,
+	cm_dentry = debugfs_create_file("custom_method", S_IWUSR,
 					acpi_dir, NULL, &cm_fops);
 	if (!cm_dentry)
 		goto err;
