Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab1DNR6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:42045 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933634Ab1DNR60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dave Jones <davej@redhat.com>,
        Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 134/209] ACPI: debugfs custom_method open to non-root
Date: Thu, 14 Apr 2011 13:54:52 -0400
Message-Id: <1302803767-9715-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit ed3aada1bf34c5a9e98af167f125f8a740fc726a upstream

Currently we have:

  --w--w--w-. 1 root root 0 2010-11-11 14:56 /sys/kernel/debug/acpi/custom_method

which is just crazy. Change this to --w-------.

[PG: back in 2.6.34, the file was called debug.c, not debugfs.c]

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/acpi/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/debug.c b/drivers/acpi/debug.c
index 146135e..469f049 100644
--- a/drivers/acpi/debug.c
+++ b/drivers/acpi/debug.c
@@ -258,7 +258,7 @@ static int acpi_debugfs_init(void)
 	if (!acpi_dir)
 		goto err;
 
-	cm_dentry = debugfs_create_file("custom_method", S_IWUGO,
+	cm_dentry = debugfs_create_file("custom_method", S_IWUSR,
 					acpi_dir, NULL, &cm_fops);
 	if (!cm_dentry)
 		goto err;
-- 
1.7.4.4

