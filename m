Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1A1Rhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:37:47 -0500
Received: from [123.122.102.109] ([123.122.102.109]:36386 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754009Ab1A1Rhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:37:46 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 12:37:46 EST
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@suse.de>
Subject: [PATCH 5/5] scsi_lib.c: use BUG_ON correctly, v3
Date: Sat, 29 Jan 2011 01:55:50 +0800
Message-Id: <1296237350-6624-6-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296237350-6624-1-git-send-email-bosong.ly@taobao.com>
References: <1296237350-6624-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes BUG_ON() usage correct in drivers/scsi/scsi_lib.c

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Martin K. Petersen<martin.petersen@oracle.com>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/scsi/scsi_lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9045c52..7790a51 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1002,8 +1002,8 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
 						prot_sdb->table.sgl);
-		BUG_ON(unlikely(count > ivecs));
-		BUG_ON(unlikely(count > queue_max_integrity_segments(rq->q)));
+		BUG_ON(count > ivecs);
+		BUG_ON(count > queue_max_integrity_segments(rq->q));
 
 		cmd->prot_sdb = prot_sdb;
 		cmd->prot_sdb->table.nents = count;
-- 
1.7.3.4

