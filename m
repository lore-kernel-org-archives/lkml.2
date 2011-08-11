Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1HKLB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:01:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53856 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab1HKK75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:59:57 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 4/9] efi.h: Add allocation types for boottime->allocate_pages()
Date: Thu, 11 Aug 2011 11:59:41 +0100
Message-Id: <1313060386-4858-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

Add the allocation types detailed in section 6.2 - "AllocatePages()"
of the UEFI 2.3 specification. These definitions will be used by the
x86 EFI boot stub which needs to allocate memory during boot.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 include/linux/efi.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index d10a639..cd28c7a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -109,6 +109,14 @@ typedef struct {
 	u32 imagesize;
 } efi_capsule_header_t;
 
+/*
+ * Allocation types for calls to boottime->allocate_pages.
+ */
+#define EFI_ALLOCATE_ANY_PAGES		0
+#define EFI_ALLOCATE_MAX_ADDRESS	1
+#define EFI_ALLOCATE_ADDRESS		2
+#define EFI_MAX_ALLOCATE_TYPE		3
+
 typedef int (*efi_freemem_callback_t) (u64 start, u64 end, void *arg);
 
 /*
-- 
1.7.4.4

