Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1LWNlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:41:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53876 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1LWNlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:41:10 -0500
MIME-Version: 1.0
Date: Fri, 23 Dec 2011 21:41:08 +0800
Message-ID: <CAJd=RBCXTp0GrMGw+MBDdj0K15+L5v+O2t6EcDghFk34aNwt1g@mail.gmail.com>
Subject: [PATCH] mm: hugetlb: add might_sleep() for gigantic page
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: hugetlb: add might_sleep() for gigantic page

Like the case of huge page, might_sleep() is added for gigantic page, then
both are treated in same way.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/hugetlb.c	Tue Dec 20 21:26:30 2011
+++ b/mm/hugetlb.c	Fri Dec 23 21:19:18 2011
@@ -401,6 +401,7 @@ static void copy_gigantic_page(struct pa
 	struct page *dst_base = dst;
 	struct page *src_base = src;

+	might_sleep();
 	for (i = 0; i < pages_per_huge_page(h); ) {
 		cond_resched();
 		copy_highpage(dst, src);
