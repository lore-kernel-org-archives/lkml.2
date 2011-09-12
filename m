Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab1ILOfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:35:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54446 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757304Ab1ILOfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:35:09 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 09/10] efi: Add EFI file I/O data types
Date: Mon, 12 Sep 2011 15:34:53 +0100
Message-Id: <1315838094-2307-10-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
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

v2: use __aligned_u64 because x86 only aligns 64-bit data types on a
   4-byte boundary unless instructed otherwise.

 include/linux/efi.h |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index d407c88..37c3007 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -307,6 +307,12 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define EFI_PCI_IO_PROTOCOL_GUID \
     EFI_GUID(  0x4cf5b200, 0x68b8, 0x4ca5, 0x9e, 0xec, 0xb2, 0x3e, 0x3f, 0x50, 0x2, 0x9a )
 
+#define EFI_FILE_INFO_ID \
+    EFI_GUID(  0x9576e92, 0x6d3f, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
+
+#define EFI_FILE_SYSTEM_GUID \
+    EFI_GUID(  0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
@@ -362,6 +368,40 @@ typedef struct {
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
+	__aligned_u64 attribute;
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

