Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1G0J4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:56:04 -0400
Received: from narfation.org ([79.140.41.39]:43168 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab1G0Jzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:55:52 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: [PATCHv4 08/11] xfs: Use *_dec_not_zero instead of *_add_unless
Date: Wed, 27 Jul 2011 11:47:47 +0200
Message-Id: <1311760070-21532-8-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311760070-21532-1-git-send-email-sven@narfation.org>
References: <1311760070-21532-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_dec_not_zero is defined for each architecture through
<linux/atomic.h> to provide the functionality of
atomic_add_unless(x, -1, 0).

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Alex Elder <aelder@sgi.com>
Cc: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index b2b4119..a68d9bf 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1429,7 +1429,7 @@ xfs_buftarg_shrink(
 		 * zero. If the value is already zero, we need to reclaim the
 		 * buffer, otherwise it gets another trip through the LRU.
 		 */
-		if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+		if (!atomic_dec_not_zero(&bp->b_lru_ref)) {
 			list_move_tail(&bp->b_lru, &btp->bt_lru);
 			continue;
 		}
-- 
1.7.5.4

