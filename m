Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab0LPRKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:10:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab0LPRKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:10:48 -0500
From: Petr Holasek <pholasek@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, akpm@linux-foundation.org,
        Petr Holasek <pholasek@redhat.com>
Subject: [PATCH] kpagecount: added slab page checking because of _mapcount in union
Date: Thu, 16 Dec 2010 18:10:40 +0100
Message-Id: <1292519440-26763-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PageSlab macro check was added before putting of _mapcount value
to /kpagecount. page->_mapcount is in union with SLAB structure
so for pages controlled by SLAB page_mapcount() returns nonsenses.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 fs/proc/page.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 3b8b456..b06c674 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -40,7 +40,7 @@ static ssize_t kpagecount_read(struct file *file, char __user *buf,
 			ppage = pfn_to_page(pfn);
 		else
 			ppage = NULL;
-		if (!ppage)
+		if (!ppage || PageSlab(ppage))
 			pcount = 0;
 		else
 			pcount = page_mapcount(ppage);
--
1.7.2.3

