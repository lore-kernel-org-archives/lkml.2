Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2KQCAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 21:00:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45706 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab2KQCAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 21:00:06 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org,
        kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] acpi_system_write_wakeup_device(): fix error check for unsigned variable.
Date: Sat, 17 Nov 2012 02:54:23 +0100
Message-Id: <1353117263-6957-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LEN variable is unsigned, therefore checking whether it is less than 0 is
useless.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/acpi/proc.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index 27adb09..37871a7 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -366,8 +366,6 @@ acpi_system_write_wakeup_device(struct file *file,
 
 	if (len > 4)
 		len = 4;
-	if (len < 0)
-		return -EFAULT;
 
 	if (copy_from_user(strbuf, buffer, len))
 		return -EFAULT;
-- 
1.7.10.4

