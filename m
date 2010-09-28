Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab0I1CIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:08:10 -0400
Received: from nm23.bullet.mail.sp2.yahoo.com ([98.139.91.93]:47321 "HELO
	nm23.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933277Ab0I1CIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:08:07 -0400
X-Yahoo-Newman-Id: 634610.30320.bm@omp1058.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: S3OmMgMVM1lZeszML_IgwiIhFV1w06A3vO2e.xW5hWvavs7
 bnAvUEMDL6y06faynkOCgD5Nk2vo9DbfLfDX.MWorYH9iXU.opGCSQfrReuJ
 PK5FyfhA_24O7jgFztyKkHeDG8trO_W8XLOyxCsDTpBe8vRkRI9GOP8yx19R
 daqcVR0QJyunfMWzTx.dqYXtd0KPftNm8m.tb7WrqPUzt..jhg45vVLrpJqo
 EnYSGpwEoiblYl_ccTvgYzxL.sZ_zJODkGlFvBLJHza1YOTvt3gf8IdSOSrs
 i5deZl1_yNcaHAx1bXbF2Wwvs3P1uP.CYayvummb.qwid6eXD_LmP87fbAAD
 ZdS_zs0gNGL48P_SgsIlud_r55DwcDJvj_OgGZg1EwljLB9LZyDTmtkVi
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v4 17/19] dpt_i2o: Add scsi_cmd_get_serial() call
Date: Mon, 27 Sep 2010 19:08:00 -0700
Message-Id: <1285639680-7545-1-git-send-email-nab@linux-iscsi.org>
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

