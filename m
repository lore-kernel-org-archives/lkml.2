Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab2HGDjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:39:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59837 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964808Ab2HGDix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:53 -0400
Message-Id: <20120807032801.082647545@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alasdair G Kergon <agk@redhat.com>
Subject: [ 34/70] dm thin: reduce endio_hook pool size
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alasdair G Kergon <agk@redhat.com>

commit 7768ed33ccdc02801c4483fc5682dc66ace14aea upstream.

Reduce the slab size used for the dm_thin_endio_hook mempool.

Allocation has been seen to fail on machines with smaller amounts
of memory due to fragmentation.

  lvm: page allocation failure. order:5, mode:0xd0
  device-mapper: table: 253:38: thin-pool: Error creating pool's endio_hook mempool

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 68694da..18f87b0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -19,7 +19,7 @@
 /*
  * Tunable constants
  */
-#define ENDIO_HOOK_POOL_SIZE 10240
+#define ENDIO_HOOK_POOL_SIZE 1024
 #define DEFERRED_SET_SIZE 64
 #define MAPPING_POOL_SIZE 1024
 #define PRISON_CELLS 1024


