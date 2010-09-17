Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0IQSWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:22:43 -0400
Received: from smtp104.sbc.mail.re3.yahoo.com ([66.196.96.80]:43422 "HELO
	smtp104.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753627Ab0IQSWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:22:41 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: suP1PU4VM1n2i7rl_USh5NlYzIhMj8dN7kE1xYOliZHu496
 hiBFP5vJ52CQXtixEq31lWjtqTUte4QPpVk7DQhEj569V5F7pZGxJ1oD.C_F
 7HGRSdJiKW36KSxI6Kt8uZVKRnBFpbLC0H_92plv_P4zg9JRU2U_pfR6slFz
 FPXFzQzKYpdIMHWaKdd.9J.2Q0drGt1_x_wveDLIzpXnPJmMPtqmg15AWuvd
 QgzXNTpceq_j2DJHA22HM2CbYUexK2ijxIRZHbipI7mQb9FPOvMEYcnQEFou
 QMVxxiCU10Mv7P.rE5.0BFXFrgbf.E6NrKYH8PHOKMNMohYKmge9Ay4RUgaH
 LRJOrn2m4CwDGWtGYiydrjtX4ks3BpBVCke8KSy4vKMRRGEiZtikiaR.uPoU
 vTR7X2o5Sb7Y0xi2XjI9kXjIRbM0CsI.Q1TrVoxdM1ecg2fFPdQdXJcYKtCq
 o7MNwe_0rVk6c
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
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH v2 06/11] libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
Date: Fri, 17 Sep 2010 11:22:36 -0700
Message-Id: <1284747756-20957-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from libata-scsi.c:ata_scsi_queuecmd()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/ata/libata-scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a89172c..33ead2a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3177,7 +3177,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	ap = ata_shost_to_port(shost);
 
-	spin_unlock(shost->host_lock);
 	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
@@ -3191,7 +3190,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	spin_unlock(ap->lock);
-	spin_lock(shost->host_lock);
 	return rc;
 }
 
-- 
1.7.2.3

