Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2KXESx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 23:18:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56194 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab2KXESw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 23:18:52 -0500
MIME-Version: 1.0
Date: Sat, 24 Nov 2012 12:18:51 +0800
Message-ID: <CAJd=RBAn-wASi7vHw2+hoU5zGE8x0pn-T_sPbtTF_HS5ha10NQ@mail.gmail.com>
Subject: [PATCH 2/3] balancenuma: free new thp if fail to isolate the old
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free newly allocated thp if fail to isolate the old.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/migrate.c	Fri Nov 23 21:29:40 2012
+++ b/mm/migrate.c	Fri Nov 23 22:52:06 2012
@@ -1624,8 +1624,10 @@ int migrate_misplaced_transhuge_page(str
 		goto out_dropref;

 	isolated = numamigrate_isolate_page(pgdat, page);
-	if (!isolated)
+	if (!isolated) {
+		put_page(new_page);
 		goto out_keep_locked;
+	}
 	list_add(&page->lru, &migratepages);

 	/* Prepare a page as a migration target */
--
