Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1BDMYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:24:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1BDMYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:24:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wdtDTJW0Fx94TPWdow3KCIQ+sW6MH1F8NLnDMajhThVyog9AZPHZ3B3GXEbNE9eoH8
         vHuq5anmrdNI4sXMQMzMgpO0YTAmPAmr8PpSi92NBfbk4LD1qDp4kGYIZ1KeuoxXEItO
         kd2EkWmmG85ldqs365n9qCpgtcxf1MJoIUico=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Corentin Chary <corentincj@iksaif.net>,
        Karol Kozimor <sziwan@users.sourceforge.net>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 15/20] platform: x86: asus_acpi: world-writable procfs files
Date: Fri,  4 Feb 2011 15:23:59 +0300
Message-Id: <59f50c896fa91e8b7822c71800c76063b0b58d2b.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to change ACPI settings.  The comment says that it
is done deliberatelly, however, the comment before disp_proc_write()
says that at least one of these setting is experimental.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/platform/x86/asus_acpi.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index 4633fd8..fe49593 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1081,14 +1081,8 @@ static int asus_hotk_add_fs(struct acpi_device *device)
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
-- 
1.7.0.4

