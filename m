Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1HKLAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:00:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53868 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab1HKLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:00:04 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 7/9] efi: Add EFI file I/O data types
Date: Thu, 11 Aug 2011 11:59:44 +0100
Message-Id: <1313060386-4858-8-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The x86 EFI stub needs to access files, for example when loading
initrd's. Add the required data types.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 include/linux/efi.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index d06e0ae..0e9e674 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -301,6 +301,12 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID \
     EFI_GUID(  0x9042a9de, 0x23dc, 0x4a38, 0x96, 0xfb, 0x7a, 0xde, 0xd0, 0x80, 0x51, 0x6a )
 
+#define EFI_FILE_INFO_ID \
+    EFI_GUID(  0x9576e92, 0x6d3f, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
+
+#define EFI_FILE_SYSTEM_GUID \
+    EFI_GUID(  0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
@@ -356,6 +362,40 @@ typedef struct {
 	unsigned long unload;
 } efi_loaded_image_t;
 
+typedef struct {
+	u64 revision;
+	void *open_volume;
+} efi_file_io_interface_t;
+
+typedef struct {
+	u64 size;
+	u64 file_size;
+	u64 phys_size;
+	efi_time_t create_time;
+	efi_time_t last_access_time;
+	efi_time_t modification_time;
+	u64 attribute;
+	efi_char16_t filename[1];
+} efi_file_info_t;
+
+typedef struct {
+	u64 revision;
+	void *open;
+	void *close;
+	void *delete;
+	void *read;
+	void *write;
+	void *get_position;
+	void *set_position;
+	void *get_info;
+	void *set_info;
+	void *flush;
+} efi_file_handle_t;
+
+#define EFI_FILE_MODE_READ	0x0000000000000001
+#define EFI_FILE_MODE_WRITE	0x0000000000000002
+#define EFI_FILE_MODE_CREATE	0x8000000000000000
+
 #define EFI_INVALID_TABLE_ADDR		(~0UL)
 
 /*
-- 
1.7.4.4

