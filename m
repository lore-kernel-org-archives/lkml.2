Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1LJCkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:40:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1LJCkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:40:41 -0500
Date: Fri, 9 Dec 2011 18:40:31 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-bb05e4ba452ada7966fbced4e829aa029f546445@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        matt.fleming@intel.com, hpa@linux.intel.com
In-Reply-To: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi.h: Add allocation types for boottime->allocate_pages()
Git-Commit-ID: bb05e4ba452ada7966fbced4e829aa029f546445
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 18:40:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb05e4ba452ada7966fbced4e829aa029f546445
Gitweb:     http://git.kernel.org/tip/bb05e4ba452ada7966fbced4e829aa029f546445
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 15 Nov 2011 12:57:03 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Dec 2011 17:35:44 -0800

efi.h: Add allocation types for boottime->allocate_pages()

Add the allocation types detailed in section 6.2 - "AllocatePages()"
of the UEFI 2.3 specification. These definitions will be used by the
x86 EFI boot stub which needs to allocate memory during boot.

Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1318848017-12301-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
