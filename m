Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab2KVTPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:15:36 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51510 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2KVTPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:15:32 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org,
        kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH v2] acpi_system_write_wakeup_device(): fix error check for unsigned variable.
Date: Thu, 22 Nov 2012 01:34:55 +0100
Message-Id: <1353544495-25277-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1645783.2WuR77RKxS@vostro.rjw.lan>
References: <1645783.2WuR77RKxS@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LEN variable is unsigned, therefore checking whether it is less than 0 is
useless. Also drop the LEN variable, since the COUNT parameter can be used
instead.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/acpi/proc.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index 27adb09..ef98796 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -362,16 +362,13 @@ acpi_system_write_wakeup_device(struct file *file,
 	struct list_head *node, *next;
 	char strbuf[5];
 	char str[5] = "";
-	unsigned int len = count;
 
-	if (len > 4)
-		len = 4;
-	if (len < 0)
-		return -EFAULT;
+	if (count > 4)
+		count = 4;
 
-	if (copy_from_user(strbuf, buffer, len))
+	if (copy_from_user(strbuf, buffer, count))
 		return -EFAULT;
-	strbuf[len] = '\0';
+	strbuf[count] = '\0';
 	sscanf(strbuf, "%s", str);
 
 	mutex_lock(&acpi_device_lock);
-- 
1.7.10.4

