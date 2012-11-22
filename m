Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2KVUz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:55:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab2KVS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:33 -0500
Date: Wed, 21 Nov 2012 18:08:52 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-cf47065961b48727b4e47bc3e2e67f4996878437@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-31-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-31-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Move back pgt_buf_* to mm/init.c
Git-Commit-ID: cf47065961b48727b4e47bc3e2e67f4996878437
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:08:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf47065961b48727b4e47bc3e2e67f4996878437
Gitweb:     http://git.kernel.org/tip/cf47065961b48727b4e47bc3e2e67f4996878437
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:07 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:36 -0800

x86, mm: Move back pgt_buf_* to mm/init.c

Also change them to static.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-31-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/init.h | 4 ----
 arch/x86/mm/init.c          | 6 +++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 4f13998..626ea8d 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -12,8 +12,4 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask);
 
-extern unsigned long __initdata pgt_buf_start;
-extern unsigned long __meminitdata pgt_buf_end;
-extern unsigned long __meminitdata pgt_buf_top;
-
 #endif /* _ASM_X86_INIT_32_H */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bed4888..3cadf10 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -19,9 +19,9 @@
 
 #include "mm_internal.h"
 
-unsigned long __initdata pgt_buf_start;
-unsigned long __meminitdata pgt_buf_end;
-unsigned long __meminitdata pgt_buf_top;
+static unsigned long __initdata pgt_buf_start;
+static unsigned long __initdata pgt_buf_end;
+static unsigned long __initdata pgt_buf_top;
 
 static unsigned long min_pfn_mapped;
 
