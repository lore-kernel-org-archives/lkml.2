Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2K0NWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:22:16 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56833 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2K0NWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:22:13 -0500
MIME-Version: 1.0
Date: Tue, 27 Nov 2012 21:22:12 +0800
Message-ID: <CAJd=RBD8VJJ75BHR9+KogGtOwaZf36Br9_ehj7oLCcCw9Qiuew@mail.gmail.com>
Subject: [PATCH 3/3] balancenuma: set last_nid on tail page
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass last_nid from head page to tail page.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/huge_memory.c	Tue Nov 27 20:45:56 2012
+++ b/mm/huge_memory.c	Tue Nov 27 20:54:54 2012
@@ -1382,6 +1382,7 @@ static void __split_huge_page_refcount(s
 		page_tail->mapping = page->mapping;

 		page_tail->index = page->index + i;
+		page_xchg_last_nid(page_tail, page_last_nid(page));

 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
--
