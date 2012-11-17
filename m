Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2KQDoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:44:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16874 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2KQDkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:39 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 28/46] x86, mm: Add pointer about Xen mmu requirement for alloc_low_pages
Date: Fri, 16 Nov 2012 19:39:05 -0800
Message-Id: <1353123563-3103-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Add link for more information
	279b706 x86,xen: introduce x86_init.mapping.pagetable_reserve

-v2: updated to commets from hpa to include commit name.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

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
-- 
1.7.7

