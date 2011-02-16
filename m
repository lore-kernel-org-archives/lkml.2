Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab1BPIup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:50:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:53763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1BPIum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:50:42 -0500
Date: Wed, 16 Feb 2011 08:50:26 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4D1933BA.8000508@kernel.org>
References: <4D1933BA.8000508@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Change get_max_mapped() to inline
Message-ID: <tip-45635ab5e41bcde94a82f9a05d660ef77fe38c1b@git.kernel.org>
Git-Commit-ID: 45635ab5e41bcde94a82f9a05d660ef77fe38c1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 08:50:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45635ab5e41bcde94a82f9a05d660ef77fe38c1b
Gitweb:     http://git.kernel.org/tip/45635ab5e41bcde94a82f9a05d660ef77fe38c1b
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Dec 2010 16:47:54 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Dec 2010 15:47:55 -0800

x86: Change get_max_mapped() to inline

Move it into head file. to prepare use it in other files.

[ hpa: added missing <linux/types.h> and changed type to phys_addr_t. ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D1933BA.8000508@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_types.h |    6 ++++++
 arch/x86/kernel/setup.c           |    9 ---------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 1df6621..93626e6 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PAGE_DEFS_H
 
 #include <linux/const.h>
+#include <linux/types.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
@@ -45,6 +46,11 @@ extern int devmem_is_allowed(unsigned long pagenr);
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+static inline phys_addr_t get_max_mapped(void)
+{
+	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
+}
+
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index df172c1..3def8c9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -669,15 +669,6 @@ static int __init parse_reservelow(char *p)
 
 early_param("reservelow", parse_reservelow);
 
-static u64 __init get_max_mapped(void)
-{
-	u64 end = max_pfn_mapped;
-
-	end <<= PAGE_SHIFT;
-
-	return end;
-}
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
