Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1AZR36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:29:58 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46015 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab1AZR34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:29:56 -0500
Date: Wed, 26 Jan 2011 11:27:06 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] zram/xvmalloc: Close 32byte hole on 64-bit CPUs
Message-ID: <20110126172706.GH8446@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110126172148.GB8446@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126172148.GB8446@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
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
index 68db384..e51eea4 100644
--- a/drivers/staging/zram/xvmalloc_int.h
+++ b/drivers/staging/zram/xvmalloc_int.h
@@ -93,12 +93,9 @@ struct block_header {
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
1.6.0.2

