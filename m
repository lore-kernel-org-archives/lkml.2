Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964Ab2KVS6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910Ab2KVS6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:40 -0500
Date: Wed, 21 Nov 2012 18:06:47 -0800
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Message-ID: <tip-ddd3509df8f8d4f1cf4784f559d702ce00dc8846@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <1353123563-3103-29-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-29-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Add pointer about Xen mmu requirement for alloc_low_pages
Git-Commit-ID: ddd3509df8f8d4f1cf4784f559d702ce00dc8846
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:06:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddd3509df8f8d4f1cf4784f559d702ce00dc8846
Gitweb:     http://git.kernel.org/tip/ddd3509df8f8d4f1cf4784f559d702ce00dc8846
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Fri, 16 Nov 2012 19:39:05 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:28 -0800

x86, mm: Add pointer about Xen mmu requirement for alloc_low_pages

Add link for more information
	279b706 x86,xen: introduce x86_init.mapping.pagetable_reserve

-v2: updated to commets from hpa to include commit name.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-29-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 02cea14..cb4f8ba 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -25,6 +25,15 @@ unsigned long __meminitdata pgt_buf_top;
 
 static unsigned long min_pfn_mapped;
 
+/*
+ * Pages returned are already directly mapped.
+ *
+ * Changing that is likely to break Xen, see commit:
+ *
+ *    279b706 x86,xen: introduce x86_init.mapping.pagetable_reserve
+ *
+ * for detailed information.
+ */
 __ref void *alloc_low_pages(unsigned int num)
 {
 	unsigned long pfn;
