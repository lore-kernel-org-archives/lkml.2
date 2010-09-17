Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0IQFfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:35:10 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:41228 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753543Ab0IQFfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:35:08 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: n0P4UjUVM1kbYXS72DkmtmaOWbj2SYUTLJUNfcPozTev7VT
 5nFXGLDhlWZpP4ase_q8_mtVyOMkGN2V.ZkDcTMZds0rSPxiB83j45ugokO8
 ewGy7Jx6QFqPWcR5k3pmIO_OMt405rJx6MfV8lZvlULGEPSNFj.LRymrPMKY
 wqxPkDiofsBDJQpQLTihuGKVUWi8AalzGvj8_flWJGFV0uInMhd.21J4EwW0
 6F9xUjGOLvqZ.djZDkrLrPtD3.ReD7leEIGl5k.tp1g0X3A4HK9WfnN1Cc_C
 91gHmqyBKoI27xi0CCsVpYeELIZlenJyPEFzT9VetrmmWj7ns3qM-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Hannes Reinecke <hare@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Joe Eykholt <jeykholt@cisco.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm_loop: Enable 32-byte CDB support in virtual SCSI LLD
Date: Thu, 16 Sep 2010 22:35:03 -0700
Message-Id: <1284701703-18389-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes tcm_loop_core.h:TL_SCSI_MAX_CMD_LEN=32 to enable the support of
> 16 byte CDB within the TCM_Loop virtual SCSI fabric module.  This value is used in
tcm_loop_fabric_scsi.c:tcm_loop_driver_probe() for struct Scsi_Host->max_cmd_len to
signal Linux/SCSI of the maximum sized CDBs the LLD is capable of handling.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_core.h b/drivers/target/tcm_loop/tcm_loop_core.h
index 36859bd..5e218a7 100644
--- a/drivers/target/tcm_loop/tcm_loop_core.h
+++ b/drivers/target/tcm_loop/tcm_loop_core.h
@@ -14,7 +14,7 @@
 /*
  * Used in tcm_loop_driver_probe() for struct Scsi_Host->max_cmd_len
  */
-#define TL_SCSI_MAX_CMD_LEN		16
+#define TL_SCSI_MAX_CMD_LEN		32
 
 #ifdef TCM_LOOP_CDB_DEBUG
 # define TL_CDB_DEBUG(x...)		printk(KERN_INFO x)
-- 
1.5.6.5

