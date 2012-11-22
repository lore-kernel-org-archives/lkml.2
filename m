Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab2KVS6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab2KVS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:33 -0500
Date: Wed, 21 Nov 2012 18:03:40 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-9985b4c6fa7d660f685918a58282275e9e35d8e0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-26-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-26-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Move min_pfn_mapped back to mm/init.c
Git-Commit-ID: 9985b4c6fa7d660f685918a58282275e9e35d8e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:03:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9985b4c6fa7d660f685918a58282275e9e35d8e0
Gitweb:     http://git.kernel.org/tip/9985b4c6fa7d660f685918a58282275e9e35d8e0
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:02 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:24 -0800

x86, mm: Move min_pfn_mapped back to mm/init.c

Also change it to static.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-26-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_types.h | 1 -
 arch/x86/kernel/setup.c           | 1 -
 arch/x86/mm/init.c                | 2 ++
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 9f6f3e6..54c9787 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -45,7 +45,6 @@ extern int devmem_is_allowed(unsigned long pagenr);
 
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
-extern unsigned long min_pfn_mapped;
 
 static inline phys_addr_t get_max_mapped(void)
 {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f7634092..2015194 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -124,7 +124,6 @@
  */
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
-unsigned long min_pfn_mapped;
 
 #ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8481892..6392bf9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -23,6 +23,8 @@ unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
 unsigned long __meminitdata pgt_buf_top;
 
+static unsigned long min_pfn_mapped;
+
 __ref void *alloc_low_page(void)
 {
 	unsigned long pfn;
