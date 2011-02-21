Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1BUPsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:48:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1BUPst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:48:49 -0500
From: Petr Holasek <pholasek@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Petr Holasek <pholasek@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: [PATCH] hugetlbfs: correct handling of negative input to /proc/sys/vm/nr_hugepages
Date: Mon, 21 Feb 2011 16:47:49 +0100
Message-Id: <1298303270-3184-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When user insert negative value into /proc/sys/vm/nr_hugepages it will result
in the setting a random number of HugePages in system (can be easily showed
at /proc/meminfo output). This patch fixes the wrong behavior so that the
negative input will result in nr_hugepages value unchanged.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 mm/hugetlb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bb0b7c1..f99d7a8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1872,8 +1872,7 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
 	unsigned long tmp;
 	int ret;
 
-	if (!write)
-		tmp = h->max_huge_pages;
+	tmp = h->max_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
 		return -EINVAL;
-- 
1.7.1

