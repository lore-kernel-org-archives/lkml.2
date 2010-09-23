Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0IWXjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:39:11 -0400
Received: from smtp104.sbc.mail.ac4.yahoo.com ([76.13.13.243]:26914 "HELO
	smtp104.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753679Ab0IWXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:39:08 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Fsje1m8VM1lUGzX6BoNJzOP9Rx6h7a_gc05cp2r2Z__YaOf
 VCeg5_c.3taLSlgedqBYNqh8fgnoYIlvmSR8JD.2dSZc8PCwrDkIolH_tzek
 3Liah.1Qtnb3ruk..fnGfb4jtJ.dYlPCoTV3YiuEzP6UR2PdbhE0mGvQo.z5
 a_GVtft5vJajbteiggU8d5naXXjK3Fgy8YR3UsK_5VPmODMSmooWeEYetJkr
 9yNQbE7hK1K5oVOfq6kPtpWUt8tC0csftRPgI_bB_zKyh39yvuCumvD0QQwu
 ey.bsaz7brvkIJ.iflSKBg5LSOnVLBT4btkqsmDf8onJhK1h_ZA--
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
Subject: [RFC v3 11/15] mpt2sas: Add scsi_cmd_get_serial() call
Date: Thu, 23 Sep 2010 16:39:02 -0700
Message-Id: <1285285142-16561-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in _scsih_qcmd() to setup a
valid struct scsi_cmnd->serial_number because mpt2sas_scsih_issue_tm()
still depends upon this being set.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..1234134 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3325,6 +3325,11 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	u16 smid;
 
 	scmd->scsi_done = done;
+	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * in mpt2sas_scsih_issue_tm()
+	 */
+	scsi_cmd_get_serial(scmd);
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
-- 
1.7.3

