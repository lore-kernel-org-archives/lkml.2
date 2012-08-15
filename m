Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2HOUd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:33:26 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62784 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab2HOTtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Marek Marczykowski <marmarek@mimuw.edu.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 029/165] xen-blkfront: fix data size for xenbus_gather in blkfront_connect
Date: Wed, 15 Aug 2012 15:46:13 -0400
Message-ID: <1345060109-9187-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Marczykowski <marmarek@mimuw.edu.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4352b47ab7918108b389a48d2163c9a4c2aaf139 upstream.

barrier variable is int, not long. This overflow caused another variable
override: "err" (in PV code) and "binfo" (in xenlinux code -
drivers/xen/blkfront/blkfront.c). The later caused incorrect device
flags (RO/removable etc).

Signed-off-by: Marek Marczykowski <marmarek@mimuw.edu.pl>
Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
[v1: Changed title]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/block/xen-blkfront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 82ed403..5d5e1ea 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -890,7 +890,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	}
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			    "feature-barrier", "%lu", &info->feature_barrier,
+			    "feature-barrier", "%d", &info->feature_barrier,
 			    NULL);
 	if (err)
 		info->feature_barrier = 0;
-- 
1.7.12.rc2

