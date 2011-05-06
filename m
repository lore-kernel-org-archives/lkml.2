Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1EFPCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:02:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46803 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab1EFPCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:02:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=snMHbyjNTrytH3oxfJnhcvOYOzSbDrHs4Jb2N0F6kSZdFE7eql+J+CoQixEm2FnoaN
         hpGQzqj0xe+F5hYd/0dzH7Uym15LYqKQP+9Xs/aA/tbdWKBkHjuwE/pk4QaclG5iN/2m
         +/bhXrJOFZsFOlLq9esb9rb3MZCfnwxn1w8qM=
Subject: [PATCH]mm/page_alloc.c: no need del from lru
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, mel@csn.ul.ie
Cc: kamezawa.hiroyu@jp.fujisu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@osdl.org>, aarcange@redhat.com
Date: Fri, 06 May 2011 23:01:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 
Content-Transfer-Encoding: 7bit
Message-ID: <1304694099.2450.3.camel@figo-desktop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


split_free_page() the page is still free page, it is no need del from lru.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---
mm/page_alloc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9f8a97b..55d8810 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1261,7 +1261,6 @@ int split_free_page(struct page *page)
 		return 0;
 
 	/* Remove page from free list */
-	list_del(&page->lru);
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));


