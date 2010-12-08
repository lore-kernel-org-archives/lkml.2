Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0LHBSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:18:23 -0500
Received: from kroah.org ([198.145.64.141]:33651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0LHBDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:16 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:43 2010
Message-Id: <20101208005743.661038922@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [222/289] ACPI: debugfs custom_method open to non-root
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/acpi/debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/debugfs.c
+++ b/drivers/acpi/debugfs.c
@@ -79,7 +79,7 @@ int __init acpi_debugfs_init(void)
 	if (!acpi_dir)
 		goto err;
 
-	cm_dentry = debugfs_create_file("custom_method", S_IWUGO,
+	cm_dentry = debugfs_create_file("custom_method", S_IWUSR,
 					acpi_dir, NULL, &cm_fops);
 	if (!cm_dentry)
 		goto err;


