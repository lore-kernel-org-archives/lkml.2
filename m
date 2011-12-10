Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1LJCj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:39:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1LJCjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:39:53 -0500
Date: Fri, 9 Dec 2011 18:39:44 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-8e84f345e2f2189a37492c77c566c7494b7b6b23@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        matt.fleming@intel.com, hpa@linux.intel.com
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi.h: Add efi_image_loaded_t
Git-Commit-ID: 8e84f345e2f2189a37492c77c566c7494b7b6b23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 18:39:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e84f345e2f2189a37492c77c566c7494b7b6b23
Gitweb:     http://git.kernel.org/tip/8e84f345e2f2189a37492c77c566c7494b7b6b23
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 15 Nov 2011 12:56:50 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 17:35:42 -0800

efi.h: Add efi_image_loaded_t

Add the EFI loaded image structure and protocol guid which are
required by the x86 EFI boot stub. The EFI boot stub uses the
structure to figure out where it was loaded in memory and to pass
command line arguments to the kernel.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1318848017-12301-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
