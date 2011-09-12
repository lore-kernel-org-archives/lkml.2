Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab1ILOgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:36:36 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54423 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757305Ab1ILOfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:35:06 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 06/10] efi.h: Add allocation types for boottime->allocate_pages()
Date: Mon, 12 Sep 2011 15:34:50 +0100
Message-Id: <1315838094-2307-7-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Add the allocation types detailed in section 6.2 - "AllocatePages()"
of the UEFI 2.3 specification. These definitions will be used by the
x86 EFI boot stub which needs to allocate memory during boot.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 include/linux/efi.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index e35005f..378f2cd 100644
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

