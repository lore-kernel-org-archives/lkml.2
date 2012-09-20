Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2ITOlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:41:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab2ITOlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:41:36 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH V2 09/10] acpi: Ignore acpi_rsdp kernel parameter in a secure boot environment
Date: Thu, 20 Sep 2012 10:41:04 -0400
Message-Id: <1348152065-31353-10-git-send-email-mjg@redhat.com>
In-Reply-To: <1348152065-31353-1-git-send-email-mjg@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel.  This
could potentially be used to circumvent the secure boot trust model.
We ignore the setting if we don't have the CAP_COMPROMISE_KERNEL capability.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9eaf708..f94341b 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -246,7 +246,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && capable(CAP_COMPROMISE_KERNEL))
 		return acpi_rsdp;
 #endif
 
-- 
1.7.11.4

