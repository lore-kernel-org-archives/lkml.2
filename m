Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0IWXiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:38:17 -0400
Received: from smtp104.sbc.mail.ac4.yahoo.com ([76.13.13.243]:26315 "HELO
	smtp104.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756390Ab0IWXiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:38:14 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: oTDOy8YVM1mQxtiGeG2t9IqfsfbOn2h0sFKBWpJ_NUhBIze
 2wBfBirgz9vn4kFF1DxHtehywBc2_kComCDHNFRVPVf3ud_FyTTbuhKqs2rb
 6Y9XMeWuc.RFsIL..LmcQaAzFxydtSI_rT7t.HWK_Nl8T1i1XbpGgjq5XJ4n
 VJQYYwx.zP.ke1OiyQIDNUPnOCLKq1iFHlHXL7h09V59V5N6IcOX4U2carMZ
 VBj3_OEaRKNKPZcRjDrrzY4j98T2gv6rMRVa6xF76wLKvU.A2DYlh0Gm_dMs
 ZqpTtZRE9lfQ9YvCHAam6uIH1pKn5SF3NofTiqcQt7iQJqOkIBWqB16d3YP1
 5Yt8WQlyO9Ki.8ugdxQ--
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
Subject: [RFC v3 05/15] libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
Date: Thu, 23 Sep 2010 16:38:09 -0700
Message-Id: <1285285089-16431-1-git-send-email-nab@linux-iscsi.org>
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
1.7.3

