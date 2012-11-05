Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2KEGQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:16:59 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46059 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2KEGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:16:57 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] [SCSI] bnx2fc: fix NULL checking in bnx2fc_initiate_tmf()
Date: Mon,  5 Nov 2012 01:15:53 -0500
Message-Id: <1352096153-18211-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dereference rport->data should come after the NULL check of rport.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 8d4626c..eebe93c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -686,7 +686,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 {
 	struct fc_lport *lport;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
-	struct fc_rport_libfc_priv *rp = rport->dd_data;
+	struct fc_rport_libfc_priv *rp;
 	struct fcoe_port *port;
 	struct bnx2fc_interface *interface;
 	struct bnx2fc_rport *tgt;
@@ -712,6 +712,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		rc = FAILED;
 		goto tmf_err;
 	}
+	rp = rport->dd_data;
 
 	rc = fc_block_scsi_eh(sc_cmd);
 	if (rc)
-- 
1.7.10.4

