Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1KUOqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:46:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab1KUOqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:46:09 -0500
Date: Mon, 21 Nov 2011 15:46:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hugetlb: clarify hugetlb_instantiation_mutex usage
Message-ID: <20111121144608.GC16957@tiehlicka.suse.cz>
References: <CAJd=RBC+p8033bHNfP=WQ2SU1Y1zRpj+FEi9FdjuFKkjF_=_iA@mail.gmail.com>
 <20111118150742.GA23223@tiehlicka.suse.cz>
 <CAJd=RBCOK9tis-bF87Csn70miRDqLtCUiZmDH2hnc8i_9+KtNw@mail.gmail.com>
 <20111118161128.GC23223@tiehlicka.suse.cz>
 <20111121122303.GA13594@tiehlicka.suse.cz>
 <20111121141625.GB16957@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121141625.GB16957@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And the follow up documentation patch:
---
>From 51bef05e4cbf97a749e6c0245114eceb21d05d61 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 21 Nov 2011 15:39:45 +0100
Subject: [PATCH] hugetlb: clarify hugetlb_instantiation_mutex usage

Let's make it clear that we cannot race with other fault handlers due to
hugetlb (global) mutex.
Also make it clear that we want to keep pte_same checks anayway to have a
transition from the global mutex easier.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/hugetlb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f76c7ea..611cdc8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2348,6 +2348,9 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 
 /*
  * Hugetlb_cow() should be called with page lock of the original hugepage held.
+ * Called with hugetlb_instantiation_mutex held and pte_page locked so we
+ * cannot race with other handlers or page migration.
+ * Keep the pte_same checks anyway to make transition from the mutex easier.
  */
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pte_t pte,
-- 
1.7.7.1


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
