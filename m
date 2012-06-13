Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2FMLc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:32:57 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49115 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2FMLcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:32:55 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 10/15] hugetlb/cgroup: Add the cgroup pointer to page lru
In-Reply-To: <1339583254-895-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 13 Jun 2012 17:02:47 +0530
Message-ID: <8762avo3a8.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061301-1618-0000-0000-000001D26659
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Need this patch for hugetlb cgroup disabled. I will send an updated patch in
reply.

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index e9e6d74..bc30413 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -18,14 +18,14 @@
 #include <linux/res_counter.h>
 
 struct hugetlb_cgroup;
-
-#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
 /*
  * Minimum page order trackable by hugetlb cgroup.
  * At least 3 pages are necessary for all the tracking information.
  */
 #define HUGETLB_CGROUP_MIN_ORDER	2
 
+#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
+
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
 {
 	VM_BUG_ON(!PageHuge(page));

