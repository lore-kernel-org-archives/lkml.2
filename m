Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1ILOfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:35:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54429 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757304Ab1ILOfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:35:05 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 05/10] efi.h: Add efi_image_loaded_t
Date: Mon, 12 Sep 2011 15:34:49 +0100
Message-Id: <1315838094-2307-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Add the EFI loaded image structure and protocol guid which are
required by the x86 EFI boot stub. The EFI boot stub uses the
structure to figure out where it was loaded in memory and to pass
command line arguments to the kernel.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2: use __aligned_u64 because x86 only aligns 64-bit data types on a
   4-byte boundary unless instructed otherwise.

 include/linux/efi.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 9547597..e35005f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -287,6 +287,9 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define LINUX_EFI_CRASH_GUID \
     EFI_GUID(  0xcfc8fc79, 0xbe2e, 0x4ddc, 0x97, 0xf0, 0x9f, 0x98, 0xbf, 0xe2, 0x98, 0xa0 )
 
+#define LOADED_IMAGE_PROTOCOL_GUID \
+    EFI_GUID(  0x5b1b31a1, 0x9562, 0x11d2, 0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
@@ -326,6 +329,22 @@ struct efi_memory_map {
 	unsigned long desc_size;
 };
 
+typedef struct {
+	u32 revision;
+	void *parent_handle;
+	efi_system_table_t *system_table;
+	void *device_handle;
+	void *file_path;
+	void *reserved;
+	u32 load_options_size;
+	void *load_options;
+	void *image_base;
+	__aligned_u64 image_size;
+	unsigned int image_code_type;
+	unsigned int image_data_type;
+	unsigned long unload;
+} efi_loaded_image_t;
+
 #define EFI_INVALID_TABLE_ADDR		(~0UL)
 
 /*
-- 
1.7.4.4

