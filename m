Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab2KVS63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814Ab2KVS6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:23 -0500
Date: Wed, 21 Nov 2012 18:19:15 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-60a8f428320918458a9a21052777eada68eebfd8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-41-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-41-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Move after_bootmem to mm_internel.h
Git-Commit-ID: 60a8f428320918458a9a21052777eada68eebfd8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:19:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60a8f428320918458a9a21052777eada68eebfd8
Gitweb:     http://git.kernel.org/tip/60a8f428320918458a9a21052777eada68eebfd8
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:17 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:45 -0800

x86, mm: Move after_bootmem to mm_internel.h

it is only used in arch/x86/mm/init*.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-41-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/mm_internal.h | 2 ++
 include/linux/mm.h        | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index dc79ac1..6b563a1 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -14,4 +14,6 @@ unsigned long kernel_physical_mapping_init(unsigned long start,
 					     unsigned long page_size_mask);
 void zone_sizes_init(void);
 
+extern int after_bootmem;
+
 #endif	/* __X86_MM_INTERNAL_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bcaab4e..64d5271 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1355,7 +1355,6 @@ extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
-extern int after_bootmem;
 
 extern __printf(3, 4)
 void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
