Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0IMS5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:57:09 -0400
Received: from daytona.panasas.com ([67.152.220.89]:36303 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754648Ab0IMS5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:57:08 -0400
From: Benny Halevy <bhalevy@panasas.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] SQUASHME: pnfs-obj: fix REQ flags usage
Date: Mon, 13 Sep 2010 20:57:01 +0200
Message-Id: <1284404221-3673-1-git-send-email-bhalevy@panasas.com>
X-Mailer: git-send-email 1.7.2.2
X-OriginalArrivalTime: 13 Sep 2010 18:57:05.0499 (UTC) FILETIME=[75553AB0:01CB5375]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes "pnfs-obj use REQ flags rather than BIO flags"

Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 fs/nfs/objlayout/objio_osd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/objlayout/objio_osd.c b/fs/nfs/objlayout/objio_osd.c
index 223980b..75d5df4 100644
--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -910,7 +910,7 @@ static int _write_mirrors(struct objio_state *ios, unsigned cur_comp)
 		} else {
 			bio = master_dev->bio;
 			/* FIXME: bio_set_dir() */
-			bio->bi_rw |= (1 << REQ_WRITE);
+			bio->bi_rw |= REQ_WRITE;
 		}
 
 		osd_req_write(or, &obj, per_dev->offset, bio, per_dev->length);
-- 
1.7.2.2

