Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2KPS1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:27:39 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:60081 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2KPS1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:27:37 -0500
X-IronPort-AV: E=Sophos;i="4.83,266,1352073600"; 
   d="scan'208";a="15857991"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <konrad.wilk@oracle.com>
CC: Roger Pau Monne <roger.pau@citrix.com>
Subject: [PATCH 1/2] xen-blkfront: free allocated page
Date: Fri, 16 Nov 2012 19:26:47 +0100
Message-ID: <1353090408-66400-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free the page allocated for the persistent grant.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
---
 drivers/block/xen-blkfront.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index f1de806..96e9b00 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -806,6 +806,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 		all_gnts = llist_del_all(&info->persistent_gnts);
 		llist_for_each_entry(persistent_gnt, all_gnts, node) {
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
+			__free_page(pfn_to_page(persistent_gnt->pfn));
 			kfree(persistent_gnt);
 		}
 		info->persistent_gnts_c = 0;
-- 
1.7.7.5 (Apple Git-26)

