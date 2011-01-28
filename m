Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1A1PAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:00:08 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48687 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1A1PAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:00:06 -0500
Date: Fri, 28 Jan 2011 09:00:03 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] [v2] zram/xvmalloc: Close 32byte hole on 64bit CPUs
Message-ID: <20110128150002.GF2062@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110128145602.GA2062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128145602.GA2062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By swapping the total_pages statistic with the lock we close a
hole in the structure for 64-bit CPUs.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/xvmalloc_int.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc_int.h b/drivers/staging/zram/xvmalloc_int.h
index 82a31fb..b5f1f7f 100644
--- a/drivers/staging/zram/xvmalloc_int.h
+++ b/drivers/staging/zram/xvmalloc_int.h
@@ -87,12 +87,9 @@ struct block_header {
 struct xv_pool {
 	ulong flbitmap;
 	ulong slbitmap[MAX_FLI];
-	spinlock_t lock;
-
+	u64 total_pages;	/* stats */
 	struct freelist_entry freelist[NUM_FREE_LISTS];
-
-	/* stats */
-	u64 total_pages;
+	spinlock_t lock;
 };
 
 #endif
-- 
1.7.0.4

