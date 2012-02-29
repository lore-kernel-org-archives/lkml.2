Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966153Ab2B2XWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:22:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46983 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2B2XWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:22:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of muthu.lkml@gmail.com designates 10.52.17.239 as permitted sender) smtp.mail=muthu.lkml@gmail.com; dkim=pass header.i=muthu.lkml@gmail.com
MIME-Version: 1.0
Date: Wed, 29 Feb 2012 18:22:14 -0500
Message-ID: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
Subject: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
From: Muthu Kumar <muthu.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com,
        Matt Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix setting bio flags in drivers (sd_dif/floppy).

Signed-off-by: Muthukumar R <muthur@gmail.com>

---------------------------

 drivers/block/floppy.c |    2 +-
 drivers/scsi/sd_dif.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

------------------------

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 9baf11e..744f078 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3832,7 +3832,7 @@ static int __floppy_read_block_0(struct
block_device *bdev)
 	bio.bi_size = size;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = 0;
-	bio.bi_flags = BIO_QUIET;
+	bio.bi_flags = (1 << BIO_QUIET);
 	init_completion(&complete);
 	bio.bi_private = &complete;
 	bio.bi_end_io = floppy_rb0_complete;
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 0cb39ff..f8fb2d6 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -408,7 +408,7 @@ int sd_dif_prepare(struct request *rq, sector_t
hw_sector, unsigned int sector_s
 			kunmap_atomic(sdt, KM_USER0);
 		}

-		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
+		bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
 	}

 	return 0;
