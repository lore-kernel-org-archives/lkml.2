Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1AZSXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:23:46 -0500
Received: from [123.122.106.155] ([123.122.106.155]:43815 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753926Ab1AZSXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:23:44 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@suse.de>
Subject: [PATCH 6/6] scsi_lib.c: use BUG_ON correctly
Date: Thu, 27 Jan 2011 02:39:53 +0800
Message-Id: <1296067193-15879-7-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch mekes BUG_ON() usage correct in drivers/scsi/scsi_lib.c

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
1.7.3.2

