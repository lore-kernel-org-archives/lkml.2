Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0IPD4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 23:56:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54609 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0IPD4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 23:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Dt2RaTvR96NNe0KxX1WXFvCpGaqs+z5ZOmmEszlOlI9/nImuAr9fmY29Oc+XlVR0b2
         L7hB1ai8FHD/VFwFnHnkYf8k73wEVozOo/NLaQCxAVl3dPeZWL/VAcmlSs8vmju1/k46
         W7mYKDYB0gF3CGNQLnRtEwtehZISR1XVrvl/Y=
From: Namhyung Kim <namhyung@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block: fix an warning of calling blk_rq_aligned()
Date: Thu, 16 Sep 2010 12:55:57 +0900
Message-Id: <1284609357-3076-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100916133005.56baad7e.sfr@canb.auug.org.au>
References: <20100916133005.56baad7e.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2nd argument of blk_rq_aligned() has changed to 'unsigned long' by
previous commit 'block: fix an address space warning in blk-map.c'.
According to that change, its caller has to be modified. This also
removes address space warnings from sparse.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/scsi/sg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 78d6163..655ab92 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1657,7 +1657,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	if (sg_allow_dio && hp->flags & SG_FLAG_DIRECT_IO &&
 	    dxfer_dir != SG_DXFER_UNKNOWN && !iov_count &&
 	    !sfp->parentdp->device->host->unchecked_isa_dma &&
-	    blk_rq_aligned(q, hp->dxferp, dxfer_len))
+	    blk_rq_aligned(q, (unsigned long)hp->dxferp, dxfer_len))
 		md = NULL;
 	else
 		md = &map_data;
-- 
1.7.2.2

