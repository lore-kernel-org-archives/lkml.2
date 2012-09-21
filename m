Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2IUJEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:04:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45252 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab2IUJEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:04:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,460,1344211200"; 
   d="scan'208";a="38699921"
From: Oliver Chick <oliver.chick@citrix.com>
To: konrad.wilk@oracle.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
CC: Oliver Chick <oliver.chick@citrix.com>
Subject: [PATCH] Change xen_vbd's flush_support and discard_secure to have type unsigned int, rather than bool
Date: Fri, 21 Sep 2012 10:04:18 +0100
Message-ID: <1348218258-4418-1-git-send-email-oliver.chick@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the type of bdev parameters to be unsigned int :1, rather than bool.
This is more consistent with the types of other features in the block drivers.

Signed-off-by: Oliver Chick <oliver.chick@citrix.com>
---
 drivers/block/xen-blkback/common.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9ad3b5e..9a54623 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -158,8 +158,8 @@ struct xen_vbd {
 	struct block_device	*bdev;
 	/* Cached size parameter. */
 	sector_t		size;
-	bool			flush_support;
-	bool			discard_secure;
+	unsigned int		flush_support:1;
+	unsigned int		discard_secure:1;
 };
 
 struct backend_info;
-- 
1.7.9.5

