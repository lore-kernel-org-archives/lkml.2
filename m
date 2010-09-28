Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab0I1CFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:05:49 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:33702 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933326Ab0I1CFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:05:47 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: MuUrWgAVM1k.H7ujWeKx5FWsZb9ckjZi894DJeCD1KvNhdp
 .FBcOAltYKLAXXph6MdblyhIphg1zsmNzYCxtIpdctXNaw0EDEb2YmzjooKh
 F1yRci32e8t6ZYi3peDMYNIGyz__MiqybYN5oviXwCz2aKjrPDdUK_F5J4Lg
 uqrVfe.IBNix7qIy4z1L7X3R0xAkt63_1tP8pODBWsI4XLEdWIM6c0beyb8e
 zciuGcKt54udueN1fyiCECckmarSOAeKIeA3yM0F8RS2XJjR.ezkUMH_2OGu
 _DF6PqUwwK5NRCZq.
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
Subject: [RFC v4 04/19] aic94xx: Set SHT->unlocked_qcmd=1 for libsas queuecommand()
Date: Mon, 27 Sep 2010 19:05:41 -0700
Message-Id: <1285639541-7284-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates aic94xx to set struct scsi_host_template->unlocked_qcmd=1
because it is using generic libsas sas_queuecommand() code which now can be
run without struct Scsi_Host->host_lock held following the original
host_lock unlock -> do_work() -> lock optimization in sas_queuecommand().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/aic94xx/aic94xx_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 3b7e83d..b236d720 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -77,6 +77,7 @@ static struct scsi_host_template aic94xx_sht = {
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
 	.this_id		= -1,
+	.unlocked_qcmd		= 1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
-- 
1.7.3

