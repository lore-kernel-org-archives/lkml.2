Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423457Ab2KNVKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:10:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48253 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422629Ab2KNVKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:10:01 -0500
Date: Wed, 14 Nov 2012 13:09:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: aquini@redhat.com, Andi Kleen <andi@firstfloor.org>,
        konrad.wilk@oracle.com, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, mst@redhat.com,
        Rik van Riel <riel@redhat.com>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: [patch resend] mm: introduce a common interface for balloon pages
 mobility fix
In-Reply-To: <alpine.DEB.2.00.1211091330330.2974@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1211141309090.16566@chino.kir.corp.google.com>
References: <20121107200113.65C4B100047@wpzn3.hot.corp.google.com> <alpine.DEB.2.00.1211091330330.2974@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build failure from "mm: introduce a common interface for balloon 
pages mobility":

mm/balloon_compaction.c: In function 'balloon_page_putback':
mm/balloon_compaction.c:243: error: implicit declaration of function '__WARN'

Generic code calls WARN_ON(), not __WARN() directly.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Still affects linux-next, original patch posted November 9.

 mm/balloon_compaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -240,7 +240,7 @@ void balloon_page_putback(struct page *page)
 		put_page(page);
 		balloon_event_count(COMPACTBALLOONRETURNED);
 	} else {
-		__WARN();
+		WARN_ON(1);
 		dump_page(page);
 	}
 	unlock_page(page);
