Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab0I1CF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:05:58 -0400
Received: from nm15-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.70]:35342 "HELO
	nm15-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933005Ab0I1CF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:05:56 -0400
X-Yahoo-Newman-Id: 245127.77382.bm@omp1011.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: aa3NOUwVM1nlxHGL1GKIprlluhO__4Ga_nSKNohnd9FFI22
 JEXc75vo64aj4DIQsUXji.LajwUixRMsYGOKd69zTEPyALptuFBTRiI7DzZj
 mI.Avz83avWILZHzWfoxA7lsubFi1dQIIrazjhkEnkM8ckoHXoAdJcBV2l5.
 5a0RyaVr09Pxa3vpbkLrED.k_bUrkAJtOYldZjORnwqkdSHiLfWrGgRD8UlN
 isLxf5YcfO1TUClq1CsQVLNLmXj8pb6V3R1fhmdZ2vkQqixPlEiq1yzyzLoM
 _xQ8nayHMF79KbAPebl2Ar.Rx0N55dtMlOWL95Yn_LMEg
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
Subject: [RFC v4 05/19] mvsas: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
Date: Mon, 27 Sep 2010 19:05:50 -0700
Message-Id: <1285639550-7304-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates mvsas to set struct scsi_host_template->unlocked_qcmd=1
because it is using generic libsas sas_queuecommand() code which now can be
run without struct Scsi_Host->host_lock held following the original
host_lock unlock -> do_work() -> lock optimization in sas_queuecommand().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/mvsas/mv_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 19ad34f..7a83e07 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -54,6 +54,7 @@ static struct scsi_host_template mvs_sht = {
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
 	.this_id		= -1,
+	.unlocked_qcmd		= 1,
 	.sg_tablesize		= SG_MX,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
-- 
1.7.3

