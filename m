Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1KXMiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:38:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47264 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1KXMiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:38:16 -0500
MIME-Version: 1.0
Date: Thu, 24 Nov 2011 20:38:14 +0800
Message-ID: <CAJd=RBCJwyo3dQAYmE3oXBBDMDa5GkePfQ_Sct_YUt5=_1-ovw@mail.gmail.com>
Subject: [PATCH] mm: compaction: push isolate search base of compact control
 one pfn ahead
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After isolated the current pfn will no longer be scanned and isolated if the
next round is necessary, so push the isolate_migratepages search base of the
given compact_control one step ahead.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/compaction.c	Thu Nov 24 20:23:28 2011
+++ b/mm/compaction.c	Thu Nov 24 20:32:41 2011
@@ -365,8 +365,10 @@ static isolate_migrate_t isolate_migrate
 		nr_isolated++;

 		/* Avoid isolating too much */
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
+			++low_pfn;
 			break;
+		}
 	}

 	acct_isolated(zone, cc);
