Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab0HLAal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:30:41 -0400
Received: from kroah.org ([198.145.64.141]:43660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759281Ab0HKX7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:15 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:04 2010
Message-Id: <20100811235504.038490176@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [092/111] HWPOISON: remove the anonymous entry
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 9b9a29ecd75e310f75a9243e1c3538ad34598fcb upstream.

(PG_swapbacked && !PG_lru) pages should not happen.
Better to treat them as unknown pages.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory-failure.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -589,7 +589,6 @@ static struct page_state {
 
 	{ lru|dirty,	lru|dirty,	"LRU",		me_pagecache_dirty },
 	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
-	{ swapbacked,	swapbacked,	"anonymous",	me_pagecache_clean },
 
 	/*
 	 * Catchall entry: must be at end.


