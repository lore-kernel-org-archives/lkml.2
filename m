Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2K0NYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:24:01 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40921 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2K0NYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:24:00 -0500
MIME-Version: 1.0
Date: Tue, 27 Nov 2012 21:23:59 +0800
Message-ID: <CAJd=RBB+SGundq6jOR0n01jQhAnEf0T5br7_3SQB7-OPuGkgzg@mail.gmail.com>
Subject: [PATCH 1/3] balancenuma: put page if avoid migrating page
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have to avoid migrating to a node that is nearly full, put page
and return zero.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/migrate.c	Tue Nov 27 20:09:38 2012
+++ b/mm/migrate.c	Tue Nov 27 20:15:00 2012
@@ -1538,9 +1538,11 @@ int numamigrate_isolate_page(pg_data_t *
 			mod_zone_page_state(page_zone(page),
 					NR_ISOLATED_ANON + page_lru,
 					HPAGE_PMD_NR);
+		return 1;
 	}

-	return 1;
+	put_page(page);
+	return 0;
 }

 /*
--
