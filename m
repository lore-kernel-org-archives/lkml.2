Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0IWXja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:39:30 -0400
Received: from smtp104.sbc.mail.re3.yahoo.com ([66.196.96.80]:41977 "HELO
	smtp104.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756392Ab0IWXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:39:27 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Zz2kvqQVM1lKVHb4dYh8RZKMowAEMZteKkK7OdJwRdSgB4u
 mZhykw9QfEhRgxCspvr5GEQtwYsZxhrjPpMgbeTJNF7lBzc1KgfUj9UjiiEt
 MoJ5yfjobJBeuRrHwyFn2X16DGD.2UEElnesY7nhK6oUNX0ReejOpMnArkPO
 S6gz4GmvOy0.HR8MFg7KdB_AyJTjC1G8iAR4pATq3gdr4HDuuB3xrdZQcWCG
 QaewX7yThVuaH5s1UaDTWKNNT5T2UnivxJTsj04XvWm5z6iSV_dykiaoQV9k
 iWloI_NkBjQNFLfh5IN4YkJWzzwXguTYfTEzt1Sif63CkmZaUz48kNUCeR4K
 GvMVn1ssBfAiI342uT_8NTNlQD395Y.ZDNI8_YdxICu5RlSRaGt2XflwSUik
 RC63hNWWO5ZI.B6o1HsZmvHLwocBqYGsmjnk4Gsb7LPJdIuPEGNpD1RrUguA
 Q3nBuhI837wpv
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v3 13/15] dpt_i2o: Add scsi_cmd_get_serial() call
Date: Thu, 23 Sep 2010 16:39:22 -0700
Message-Id: <1285285162-16606-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in adpt_queue() to setup a
valid struct scsi_cmnd->serial_number because adpt_cmd_to_context() still
depends upon this being set.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/dpt_i2o.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index ffc1edf..b4dfaf7 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -429,6 +429,11 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 
 	cmd->scsi_done = done;
 	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * for adpt_cmd_to_context()
+	 */
+	scsi_cmd_get_serial(cmd);
+	/*
 	 * SCSI REQUEST_SENSE commands will be executed automatically by the 
 	 * Host Adapter for any errors, so they should not be executed 
 	 * explicitly unless the Sense Data is zero indicating that no error 
-- 
1.7.3

