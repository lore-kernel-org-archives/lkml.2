Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0IWXjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:39:49 -0400
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:22453 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756301Ab0IWXjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:39:46 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: QNUL0QgVM1lsJ1xFiL1a_eEhhxWxbLvxC3fzvDUNPfq8uug
 T4ypX73Mp8iqOjQkiSdXJkRUikhbJo6Cj2nIoWTKG9fgixjQ.Qsph0eivuyr
 LotHbXa9gfGegE8_XFwkMR.MWaNOSmAtSzlysPKUaLVCLXdbOdUzEP6pzUqM
 p4nzhM9j6LoBL7uh9Akps5KNq48coulVjlOMDkB.lRpGClhWkpmhE14h2Vk6
 jLw4kkqpDMd4zUA7spk55EvG3k.I5RdjBRAoQH9_3PG5z43_jOwyBnBKCVid
 9SaqlLErsU.PZLB1aU83hLMqOQYdjsE7Ug1N52369KlNsBmlKV3hxMVE2gSq
 ZKWd18s6YG1LfYtHQTK0QM54dF9Rcc6_EZas0fkPCF1KHHuOH83WwFmjKEle
 8FEG5Tmz7AxeeXB85E7IHpRCLLRgqn_Vzsq2uAJcGFdO3mvjez.9WKsrB_Pa
 j_5vKHCL2ua.r
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
Subject: [RFC v3 15/15] u14-34f: Add scsi_cmd_get_serial() call
Date: Thu, 23 Sep 2010 16:39:42 -0700
Message-Id: <1285285182-16646-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in u14_34f_queuecommand()
to setup a valid struct scsi_cmnd->serial_number because reorder() still
depends upon this being set.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/u14-34f.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 5d9fdee..ea20906 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1255,6 +1255,12 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
    /* j is the board number */
    j = ((struct hostdata *) SCpnt->device->host->hostdata)->board_number;
 
+   /*
+    * Call scsi_cmd_get_serial() because we need a valid serial number
+    * for reorder().
+    */
+   scsi_cmd_get_serial(SCpnt);
+
    if (SCpnt->host_scribble)
       panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
             BN(j), SCpnt->serial_number, SCpnt);
-- 
1.7.3

