Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0LQROS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 12:14:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62680 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab0LQROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LE6LF47BA/04V/b6D7rX8FB9O17w+vrxEsBSJUEcadiPGhGwqKZ3RKfRtG/lCxORDW
         zoCZ6TtZDP9ycfEe2htile5G8LjvqWU9dPTwlA4YyVoB7ftrsj5z4pNY+QiZIepbITav
         OwUsJCCIgUA2NbqyyK8MP5KRDYv16PwQ6WbIs=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC 5/5] truncate: Remove unnecessary page release
Date: Sat, 18 Dec 2010 02:13:40 +0900
Message-Id: <02ab98b3a1450f7a1c31edc48ccc57e887cee900.1292604746.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1292604745.git.minchan.kim@gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1292604745.git.minchan.kim@gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series changes remove_from_page_cache's page ref counting
rule. page cache ref count is decreased in remove_from_page_cache.
So we don't need call again in caller context.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/truncate.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 9ee5673..8decb93 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -114,7 +114,6 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	 * calls cleancache_put_page (and note page->mapping is now NULL)
 	 */
 	cleancache_flush_page(mapping, page);
-	page_cache_release(page);	/* pagecache ref */
 	return 0;
 }
 
-- 
1.7.0.4

