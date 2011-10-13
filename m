Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1JMMwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 08:52:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63149 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1JMMwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 08:52:24 -0400
MIME-Version: 1.0
Date: Thu, 13 Oct 2011 20:52:22 +0800
Message-ID: <CAJd=RBALaNJ680JzCP8KUaDO80dM+9_AK5yW9SSVoUD0G1Cxzw@mail.gmail.com>
Subject: [PATCH] mm/huge_memory: Clean up typo when updating mmu cache
From: Hillf Danton <dhillf@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea

There are three cases of update_mmu_cache() in the file, and the case in
function collapse_huge_page() has a typo, namely the last parameter used,
which is corrected based on the other two cases.

Due to the define of update_mmu_cache by X86, the only arch that implements
THP currently, the change here has no really crystal point, but one or two
minutes of efforts could be saved for those archs that are likely to support
THP in future.

Thanks

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/huge_memory.c	Sat Aug 13 11:45:14 2011
+++ b/mm/huge_memory.c	Thu Oct 13 20:07:29 2011
@@ -1906,7 +1906,7 @@ static void collapse_huge_page(struct mm
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache(vma, address, entry);
+	update_mmu_cache(vma, address, _pmd);
 	prepare_pmd_huge_pte(pgtable, mm);
 	mm->nr_ptes--;
 	spin_unlock(&mm->page_table_lock);
