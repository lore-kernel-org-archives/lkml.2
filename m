Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2IYPlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:41:05 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6206 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab2IYPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:41:03 -0400
Date: Tue, 25 Sep 2012 09:41:00 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
To: Matthew Garrett <mjg@redhat.com>, hpa@zytor.com, keescook@chromium.org,
        tony.luck@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        cbouatmailru@gmail.com, ccross@android.com,
        paul.gortmaker@windriver.com, maxin.john@gmail.com,
        matt.fleming@intel.com, olof@lixom.net, dhowells@redhat.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        khalid@gonehiking.org
Subject: [PATCH -next v2] Shorten constant names for EFI variable attributes
Message-ID: <20120925154100.GA13412@ldl.usa.hp.com>
References: <20120720220841.GA32642@hp.com>
 <5009D770.1050905@zytor.com>
 <20120723132656.GC21495@srcf.ucam.org>
 <50117E40.8090904@hp.com>
 <20120726173332.GA19851@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726173332.GA19851@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace very long constants for EFI variable attributes with
shorter and more convenient names. Also create an alias for
the current longer names so as to not break compatibility
with current API since these constants are used by
userspace programs.


Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
Cc: Khalid Aziz <khalid@gonehiking.org>
---
Change for v2: Made only the new constant names available for use in kernel by
	adding #ifndef __KERNEL__ around aliases for old constant names

 drivers/firmware/efivars.c     |   20 ++++++++------------
 drivers/firmware/google/gsmi.c |    8 ++------
 include/linux/efi.h            |   37 ++++++++++++++++++++++---------------
 3 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d10c987..27f4fab 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -122,10 +122,7 @@ struct efivar_attribute {
 	ssize_t (*store)(struct efivar_entry *entry, const char *buf, size_t count);
 };
 
-#define PSTORE_EFI_ATTRIBUTES \
-	(EFI_VARIABLE_NON_VOLATILE | \
-	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
-	 EFI_VARIABLE_RUNTIME_ACCESS)
+#define PSTORE_EFI_ATTRIBUTES	(EFI_VAR_NV | EFI_VAR_BOOT | EFI_VAR_RUNTIME)
 
 #define EFIVAR_ATTR(_name, _mode, _show, _store) \
 struct efivar_attribute efivar_attr_##_name = { \
@@ -435,22 +432,21 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
-	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
+	if (var->Attributes & EFI_VAR_NV)
 		str += sprintf(str, "EFI_VARIABLE_NON_VOLATILE\n");
-	if (var->Attributes & EFI_VARIABLE_BOOTSERVICE_ACCESS)
+	if (var->Attributes & EFI_VAR_BOOT)
 		str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
-	if (var->Attributes & EFI_VARIABLE_RUNTIME_ACCESS)
+	if (var->Attributes & EFI_VAR_RUNTIME)
 		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
-	if (var->Attributes & EFI_VARIABLE_HARDWARE_ERROR_RECORD)
+	if (var->Attributes & EFI_VAR_HW_ERR)
 		str += sprintf(str, "EFI_VARIABLE_HARDWARE_ERROR_RECORD\n");
-	if (var->Attributes & EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS)
+	if (var->Attributes & EFI_VAR_AUTH_WRITE)
 		str += sprintf(str,
 			"EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS\n");
-	if (var->Attributes &
-			EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS)
+	if (var->Attributes & EFI_VAR_TIMED_AUTH_WRITE)
 		str += sprintf(str,
 			"EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS\n");
-	if (var->Attributes & EFI_VARIABLE_APPEND_WRITE)
+	if (var->Attributes & EFI_VAR_APPEND)
 		str += sprintf(str, "EFI_VARIABLE_APPEND_WRITE\n");
 	return str - buf;
 }
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 91ddf0f..3e2d6d4 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -353,9 +353,7 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
 		memcpy(data, gsmi_dev.data_buf->start, *data_size);
 
 		/* All variables are have the following attributes */
-		*attr = EFI_VARIABLE_NON_VOLATILE |
-			EFI_VARIABLE_BOOTSERVICE_ACCESS |
-			EFI_VARIABLE_RUNTIME_ACCESS;
+		*attr = EFI_VAR_NV | EFI_VAR_BOOT | EFI_VAR_RUNTIME;
 	}
 
 	spin_unlock_irqrestore(&gsmi_dev.lock, flags);
@@ -430,9 +428,7 @@ static efi_status_t gsmi_set_variable(efi_char16_t *name,
 		.name_ptr = gsmi_dev.name_buf->address,
 		.data_ptr = gsmi_dev.data_buf->address,
 		.data_len = (u32)data_size,
-		.attributes = EFI_VARIABLE_NON_VOLATILE |
-			      EFI_VARIABLE_BOOTSERVICE_ACCESS |
-			      EFI_VARIABLE_RUNTIME_ACCESS,
+		.attributes = EFI_VAR_NV | EFI_VAR_BOOT | EFI_VAR_RUNTIME,
 	};
 	size_t name_len = utf16_strlen(name, GSMI_BUF_SIZE / 2);
 	efi_status_t ret = EFI_SUCCESS;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec45ccd..9240a5e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -551,21 +551,28 @@ extern int __init efi_setup_pcdp_console(char *);
 /*
  * Variable Attributes
  */
-#define EFI_VARIABLE_NON_VOLATILE       0x0000000000000001
-#define EFI_VARIABLE_BOOTSERVICE_ACCESS 0x0000000000000002
-#define EFI_VARIABLE_RUNTIME_ACCESS     0x0000000000000004
-#define EFI_VARIABLE_HARDWARE_ERROR_RECORD 0x0000000000000008
-#define EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS 0x0000000000000010
-#define EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS 0x0000000000000020
-#define EFI_VARIABLE_APPEND_WRITE	0x0000000000000040
-
-#define EFI_VARIABLE_MASK 	(EFI_VARIABLE_NON_VOLATILE | \
-				EFI_VARIABLE_BOOTSERVICE_ACCESS | \
-				EFI_VARIABLE_RUNTIME_ACCESS | \
-				EFI_VARIABLE_HARDWARE_ERROR_RECORD | \
-				EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS | \
-				EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS | \
-				EFI_VARIABLE_APPEND_WRITE)
+#define EFI_VAR_NV			0x0000000000000001
+#define EFI_VAR_BOOT			0x0000000000000002
+#define EFI_VAR_RUNTIME			0x0000000000000004
+#define EFI_VAR_HW_ERR			0x0000000000000008
+#define EFI_VAR_AUTH_WRITE		0x0000000000000010
+#define EFI_VAR_TIMED_AUTH_WRITE	0x0000000000000020
+#define EFI_VAR_APPEND			0x0000000000000040
+
+#ifndef __KERNEL__
+#define EFI_VARIABLE_NON_VOLATILE			EFI_VAR_NV
+#define EFI_VARIABLE_BOOTSERVICE_ACCESS			EFI_VAR_BOOT
+#define EFI_VARIABLE_RUNTIME_ACCESS			EFI_VAR_RUNTIME
+#define EFI_VARIABLE_HARDWARE_ERROR_RECORD		EFI_VAR_HW_ERR
+#define EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS		EFI_VAR_AUTH_WRITE
+#define EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS \
+							EFI_VAR_TIMED_AUTH_WRITE
+#define EFI_VARIABLE_APPEND_WRITE			EFI_VAR_APPEND
+#endif
+
+#define EFI_VARIABLE_MASK	(EFI_VAR_NV | EFI_VAR_BOOT | EFI_VAR_RUNTIME | \
+				EFI_VAR_HW_ERR | EFI_VAR_AUTH_WRITE | \
+				EFI_VAR_TIMED_AUTH_WRITE | EFI_VAR_APPEND)
 /*
  * The type of search to perform when calling boottime->locate_handle
  */
-- 
1.7.8.3

