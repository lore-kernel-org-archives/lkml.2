Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0I3Dum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:50:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0I3Duk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BZWpd2J+iGVwm1lhyMq8lD9asGtWpidtFc2RSY0HX75OAzwv2fiXhM/HoEmGgS5Cvq
         i9XqzmViA57gp3Fsik6bt05PluvKbyf+YC4YGtQo0Bdi8Zy6T3im7Ol9yoR6AgNbOhy9
         oq7vwin4+lJL923ohLIHw28hk5TVxeWO5LcZo=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] mm: add lock release annotation on do_wp_page()
Date: Thu, 30 Sep 2010 12:50:13 +0900
Message-Id: <1285818621-29890-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The do_wp_page() releases @ptl but was missing proper annotation.
Add it. This removes following warnings from sparse:

 mm/memory.c:2337:9: warning: context imbalance in 'do_wp_page' - unexpected unlock
 mm/memory.c:3142:19: warning: context imbalance in 'handle_mm_fault' - different lock contexts for basic block

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/memory.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 219b50a..76fa60e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2107,6 +2107,7 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
 static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		spinlock_t *ptl, pte_t orig_pte)
+	__releases(ptl)
 {
 	struct page *old_page, *new_page;
 	pte_t entry;
-- 
1.7.2.2

