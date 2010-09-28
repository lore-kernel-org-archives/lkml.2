Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab0I1CGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:06:40 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:47320 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933466Ab0I1CGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:06:36 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: gIIPtNsVM1kU6LZqoliwXQCTgDU06IgCffcUqmwuiiEypvS
 MfsaNUrTArlwykII1l6Yd8S2rUi20Nt9ehOHN888jCdJx9yY9Wt6S6b5vT4g
 A9wcYkedZxGuwKGv6SjFN._VYSHvl9zA21x..AvspZL_w9pfS.mMeKibuFsC
 Hz04mzQis0I86PyW26HNoI4GeYD2Z.qEwtTqhQQxP16fuVj_36zIPkkRyZuD
 Od3yq23cGaqWcfaDjP6vOFE5mcWmxwcStYA42jrvmr5CBdwbJIM7jZtPYKPQ
 7icIC.7BbabN4qyMMdu1v_4Cai65N9yXXSrU_xxzPSew-
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
Subject: [RFC v4 08/19] fcoe: Set SHT->unlocked_qcmd=1 for libfc fc_queuecommand()
Date: Mon, 27 Sep 2010 19:06:27 -0700
Message-Id: <1285639587-7365-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates fcoe to set struct scsi_host_template->unlocked_qcmd=1
because it is using generic libfc fc_queuecommand() code which now can be
run without struct Scsi_Host->host_lock held following the original
host_lock unlock -> do_work() -> lock optimization in fc_queuecommand().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/fcoe/fcoe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 844d618..23b01d5 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -250,6 +250,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.change_queue_depth = fc_change_queue_depth,
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
+	.unlocked_qcmd = 1,
 	.cmd_per_lun = 3,
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
 	.use_clustering = ENABLE_CLUSTERING,
-- 
1.7.3

