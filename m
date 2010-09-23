Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0IWXi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:38:28 -0400
Received: from nm28-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.234]:43696 "HELO
	nm28-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756460Ab0IWXiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:38:24 -0400
X-Yahoo-Newman-Id: 777003.53160.bm@omp1039.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: IytOTV4VM1kKT0FjLPh5aXeMDgE7yPY6uR7H3fceaNHYyec
 pqVL1mKs2dAD8ijW4waTSt_8YjSXQa0HG8eprmc9GavVFEYk_3Bu7O.TmSVx
 gfpRWzYJ4OKld3Uby7HUv9iVZp61Y6yBhMXaAh8aK_aDY6fqjsOVcFTU8n.h
 sEB1CCWDC8XtXergk.UfgQ2FAug2GovFiRisEDtf4Zn3Rc31SgI51vz_Q1Yq
 3MNWjKEBWtuxnmaS8dkBIKZ3AwaO0UEGfOlWUI_Bm0GX_AnkM7J5hR_FDIhl
 qe.7TBE6DNVR7i9H6BMsafPjPF8IDZNhRE5zf4tKN1RNWIvt9g5g_79ilGn.
 1hlXhzhR.QG42v2g6hg--
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
Subject: [RFC v3 06/15] lpfc: Remove host_lock unlock() + lock() from lpfc_queuecommand()
Date: Thu, 23 Sep 2010 16:38:19 -0700
Message-Id: <1285285099-16451-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from lpfc_scsi.c:lpfc_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 2e51aa6..4b085f6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3023,11 +3023,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		goto out_host_busy_free_buf;
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		spin_unlock(shost->host_lock);
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
-		spin_lock(shost->host_lock);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
-- 
1.7.3

