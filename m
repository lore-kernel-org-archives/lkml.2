Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2HVDCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 23:02:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58457 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2HVDCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:02:35 -0400
MIME-Version: 1.0
Date: Wed, 22 Aug 2012 11:02:34 +0800
Message-ID: <CACV3sb+nocqeDiM+4m+hv1ygu=KAxD6CpR5wQmawkKMdAuXbgA@mail.gmail.com>
Subject: [PATCH] MIPS/mm: add compound tail page _mapcount when mapped
From: Jovi Zhang <bookjovi@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mips@linux-mips.org,
        Youquan Song <youquan.song@intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3dc19ea2b535719d0b4177f17bbbff9cbf257b23 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 22 Aug 2012 10:34:08 +0800
Subject: [PATCH] MIPS/mm: add compound tail page _mapcount when mapped

see commit b6999b191 which target for x86 mm/gup, let it align with
mips architecture.

Quote from commit b6999b191:
    "If compound pages are used and the page is a
    tail page, gup_huge_pmd() increases _mapcount to record tail page are
    mapped while gup_huge_pud does not do that."

Signed-off-by: Jovi Zhang <boojovi@gmail.com>
Cc: Youquan Song <youquan.song@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@vger.kernel.org>
---
 arch/mips/mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
index 33aadbc..dcfd573 100644
--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -152,6 +152,8 @@ static int gup_huge_pud(pud_t pud, unsigned long
addr, unsigned long end,
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
+		if (PageTail(page))
+			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
-- 
1.7.9.7
