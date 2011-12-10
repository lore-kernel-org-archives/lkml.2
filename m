Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab1LJCnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:43:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1LJCnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:43:00 -0500
Date: Fri, 9 Dec 2011 18:42:51 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-55839d515495e766605d7aaabd9c2758370a8d27@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        matt.fleming@intel.com, hpa@linux.intel.com
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi: Add EFI file I/O data types
Git-Commit-ID: 55839d515495e766605d7aaabd9c2758370a8d27
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 18:42:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55839d515495e766605d7aaabd9c2758370a8d27
Gitweb:     http://git.kernel.org/tip/55839d515495e766605d7aaabd9c2758370a8d27
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Thu, 11 Aug 2011 10:28:06 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 17:35:51 -0800

efi: Add EFI file I/O data types

The x86 EFI stub needs to access files, for example when loading
initrd's. Add the required data types.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1318848017-12301-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
