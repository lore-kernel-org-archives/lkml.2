Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1KQXW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:22:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38842 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1KQXW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:22:56 -0500
Date: Thu, 17 Nov 2011 15:22:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, linux-arch@vger.kernel.org,
        Robin Holt <holt@sgi.com>
Subject: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and
 HPAGE_SIZE
In-Reply-To: <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dummy, non-zero definitions for HPAGE_MASK and HPAGE_SIZE were added in
51c6f666fceb ("mm: ZAP_BLOCK causes redundant work") to avoid a divide
by zero in generic kernel code.

That code has since been removed, but probably should never have been
added in the first place: we don't want HPAGE_SIZE to act like PAGE_SIZE
for code that is working with hugepages, for example, when the dependency
on CONFIG_HUGETLB_PAGE has not been fulfilled.

Because hugepage size can differ from architecture to architecture, each
is required to have their own definitions for both HPAGE_MASK and
HPAGE_SIZE.  This is always done in arch/*/include/asm/page.h.

So, just remove the dummy and dangerous definitions since they are no
longer needed and reveals the correct dependencies.  Tested on
architectures using the definitions with allyesconfig: x86 (even with
thp), hppa, mips, powerpc, s390, sh3, sh4, sparc, and sparc64, and
with defconfig on ia64.

Cc: Robin Holt <holt@sgi.com>
Cc: David Daney <david.daney@cavium.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/hugetlb.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -110,11 +110,6 @@ static inline void copy_huge_page(struct page *dst, struct page *src)
 
 #define hugetlb_change_protection(vma, address, end, newprot)
 
-#ifndef HPAGE_MASK
-#define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
-#define HPAGE_SIZE	PAGE_SIZE
-#endif
-
 #endif /* !CONFIG_HUGETLB_PAGE */
 
 #define HUGETLB_ANON_FILE "anon_hugepage"
