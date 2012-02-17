Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2BQO2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:28:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62857 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2BQO2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:28:20 -0500
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/2] rmap: Staticize page_referenced_file and page_referenced_anon
Date: Fri, 17 Feb 2012 09:27:49 -0500
Message-Id: <1329488869-7270-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staticize the page_referenced_anon and page_referenced_file
functions.
These functions are called only from page_referenced.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/rmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index c8454e0..74aff97 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -772,7 +772,7 @@ out:
 	return referenced;
 }
 
-static int page_referenced_anon(struct page *page,
+static inline int page_referenced_anon(struct page *page,
 				struct mem_cgroup *memcg,
 				unsigned long *vm_flags)
 {
@@ -821,7 +821,7 @@ static int page_referenced_anon(struct page *page,
  *
  * This function is only called from page_referenced for object-based pages.
  */
-static int page_referenced_file(struct page *page,
+static inline int page_referenced_file(struct page *page,
 				struct mem_cgroup *memcg,
 				unsigned long *vm_flags)
 {
-- 
1.7.5.4

