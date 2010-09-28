Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab0I1CGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:06:11 -0400
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:32373 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933466Ab0I1CGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:06:07 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 6LRYiPgVM1mulHpsjAo3v3KgKRhwJbn_48J0dl4pcnJxv5l
 aVLkeGzs5SHf7J2ZBJ.wlGtRmxr4S8G7H3HHDlwJfTKF8MPLtGnA3Jzy6j7J
 zg78_0lcOy6d9iODAFtTMV86sT_qA_93olqC955o9D6kBdsUW50CZVSecJNn
 IxsLdnrFlp8UDvAmH64eyG8666ofnRNeDqCZVsxfKzGELBjN12GLBbnHkryc
 utg29rLkL539.aNziL1d2TModxV9i1Fu58rFx.gi495etMNuR3YUzMyL48im
 k8wKsDLDZK8b.36e3n3J5yr89W6AZJpqNpYSKLcQZ1ozLmOny2BtXYIaS8ux
 Ti7ccEKmrHIR3fg61Buo5REknIjxxSpkwfgfUy_362_aecKShAC0tOKv87P8
 gudXG9lDievw_vPIkEPJHGWitCqyJAZIRz3AdU38b
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
Subject: [RFC v4 06/19] pm8001: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
Date: Mon, 27 Sep 2010 19:06:00 -0700
Message-Id: <1285639560-7325-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates pm8001 to set struct scsi_host_template->unlocked_qcmd=1
because it is using generic libsas sas_queuecommand() code which now can be
run without struct Scsi_Host->host_lock held following the original
host_lock unlock -> do_work() -> lock optimization in sas_queuecommand().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/pm8001/pm8001_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f8c86b2..96e1dd6 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -69,6 +69,7 @@ static struct scsi_host_template pm8001_sht = {
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
 	.this_id		= -1,
+	.unlocked_qcmd		= 1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
-- 
1.7.3

