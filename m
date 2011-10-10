Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1JJP2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:28:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47721 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1JJP2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:28:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, Jan Beulich <JBeulich@novell.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Li Dongyang <lidongyang@novell.com>
Subject: [PATCH 2/3] xen/blkback: Fix the inhibition to map pages when discarding sector ranges.
Date: Mon, 10 Oct 2011 11:28:13 -0400
Message-Id: <1318260494-27985-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090204.4E930F19.0022,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'operation' parameters are the ones provided to the bio layer while
the req->operation are the ones passed in between the backend and
frontend. We used the wrong 'operation' value to squash the
call to map pages when processing the discard operation resulting
in mapping the pages unnecessarily.

CC: Li Dongyang <lidongyang@novell.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 184b133..3da9a40 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -707,7 +707,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (operation != BLKIF_OP_DISCARD &&
+	if (operation != REQ_DISCARD &&
 			xen_blkbk_map(req, pending_req, seg))
 		goto fail_flush;
 
-- 
1.7.5.4

