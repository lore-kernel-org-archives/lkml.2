Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab2ARTp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:45:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab2ARToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:44:21 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>
Cc: Azael Avalos <coproscefalo@gmail.com>, Thomas Renninger <trenn@suse.de>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] ACPI: EC: Add ec_get_handle()
Date: Wed, 18 Jan 2012 13:44:08 -0600
Message-Id: <1326915852-19896-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com>
References: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

toshiba_acpi needs to execute an AML method within the EC namespace
to make hotkeys work on some platforms. Provide an interface to
allow it to easily get a handle to the EC namespace for this purpose.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/acpi/ec.c    |   10 ++++++++++
 include/linux/acpi.h |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index b19a18d..e37615f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -445,6 +445,16 @@ int ec_transaction(u8 command,
 
 EXPORT_SYMBOL(ec_transaction);
 
+/* Get the handle to the EC device */
+acpi_handle ec_get_handle(void)
+{
+	if (!first_ec)
+		return NULL;
+	return first_ec->handle;
+}
+
+EXPORT_SYMBOL(ec_get_handle);
+
 void acpi_ec_block_transactions(void)
 {
 	struct acpi_ec *ec = first_ec;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6001b4da..ecccbb7 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -151,6 +151,7 @@ extern int ec_write(u8 addr, u8 val);
 extern int ec_transaction(u8 command,
                           const u8 *wdata, unsigned wdata_len,
                           u8 *rdata, unsigned rdata_len);
+extern acpi_handle ec_get_handle(void);
 
 #if defined(CONFIG_ACPI_WMI) || defined(CONFIG_ACPI_WMI_MODULE)
 
-- 
1.7.8.3

