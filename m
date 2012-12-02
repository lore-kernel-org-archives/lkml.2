Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2LBDSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 22:18:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62991 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2LBDRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 22:17:47 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        bprakash@broadcom.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH 3/6] scsi: bnx2fc: remove useless calls to memset().
Date: Sun,  2 Dec 2012 03:40:19 +0100
Message-Id: <1354416022-20189-4-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
References: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These calls are followed by calls to memcpy() on the same memory area, so they
can be safely removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index ef60afa..9be42b8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -759,8 +759,6 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 		case FCOE_ERROR_CODE_DATA_SOFN_SEQ_ACTIVE_RESET:
 			BNX2FC_TGT_DBG(tgt, "REC TOV popped for xid - 0x%x\n",
 				   xid);
-			memset(&io_req->err_entry, 0,
-			       sizeof(struct fcoe_err_report_entry));
 			memcpy(&io_req->err_entry, err_entry,
 			       sizeof(struct fcoe_err_report_entry));
 			if (!test_bit(BNX2FC_FLAG_SRR_SENT,
@@ -847,8 +845,6 @@ ret_err_rqe:
 			goto ret_warn_rqe;
 		}
 
-		memset(&io_req->err_entry, 0,
-		       sizeof(struct fcoe_err_report_entry));
 		memcpy(&io_req->err_entry, err_entry,
 		       sizeof(struct fcoe_err_report_entry));
 
-- 
1.7.10.4

