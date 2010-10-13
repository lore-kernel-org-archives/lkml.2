Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0JMMvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:51:45 -0400
Received: from smtp.nokia.com ([192.100.122.233]:56135 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0JMMvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:51:44 -0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
        Roman Borisov <ext-roman.borisov@nokia.com>
Subject: [PATCH] nfs: fix unchecked value
Date: Wed, 13 Oct 2010 16:54:51 +0400
Message-Id: <a4f05d53b0912562f2950958831579f14c60dbb8.1286973348.git.ext-roman.borisov@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 13 Oct 2010 12:51:32.0926 (UTC) FILETIME=[5CE4ADE0:01CB6AD5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value of "decode_attr_bitmap()" was not checked;

Signed-off-by: Roman Borisov <ext-roman.borisov@nokia.com>
---
 fs/nfs/nfs4xdr.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 6ea5c93..9e9cb40 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -2676,7 +2676,10 @@ out_overflow:
 static int decode_attr_supported(struct xdr_stream *xdr, uint32_t *bitmap, uint32_t *bitmask)
 {
 	if (likely(bitmap[0] & FATTR4_WORD0_SUPPORTED_ATTRS)) {
-		decode_attr_bitmap(xdr, bitmask);
+		int ret;
+		ret = decode_attr_bitmap(xdr, bitmask);
+		if (unlikely(ret < 0))
+			return ret;
 		bitmap[0] &= ~FATTR4_WORD0_SUPPORTED_ATTRS;
 	} else
 		bitmask[0] = bitmask[1] = 0;
-- 
1.7.0.4

