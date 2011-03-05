Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab1CEBQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:16:16 -0500
Received: from kroah.org ([198.145.64.141]:50209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760272Ab1CEBAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:36 2011
Message-Id: <20110305005636.735208441@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Namhyung Kim <namhyung@gmail.com>
Subject: [22/73] mm: fix dubious code in __count_immobile_pages()
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Namhyung Kim <namhyung@gmail.com>

commit 29723fccc837d20039078f7a571e8d457eb0d6c6 upstream.

When pfn_valid_within() failed 'iter' was incremented twice.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5335,10 +5335,9 @@ __count_immobile_pages(struct zone *zone
 	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
 		unsigned long check = pfn + iter;
 
-		if (!pfn_valid_within(check)) {
-			iter++;
+		if (!pfn_valid_within(check))
 			continue;
-		}
+
 		page = pfn_to_page(check);
 		if (!page_count(page)) {
 			if (PageBuddy(page))


