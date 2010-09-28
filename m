Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab0I1CI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:08:29 -0400
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:48018 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932157Ab0I1CIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:08:25 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: bzSrgLQVM1kQVVuzPYSsvB2kh9bdVFvW9Gk_HkGRF.c0CYJ
 xqsu5tMcBkAZGOggLWUycki8kf9eKRb0MAFR1QVbg8v0stbGRyppZ5Qty_sd
 a0vkAUMG.S5iZKIypX2dcxOVYIlZFo7YBJY82_kyte6eCX9T5rlha7Mrm_h2
 bGLfT5aYjrhRk1uqLmB5SG2aK3djo_yhUnzLI85Z6YkN49iDGAsStsqjDykP
 sP8eyIxXPWKXAACjgNXZ.NTYx500hG.44b0bx7Bqti9m.1j1ls58ptwwjBzf
 SS2VM9WLK4CqVAkVtKX5SaXfAxEZ47Ia86J1pNFPovOM-
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
Subject: [RFC v4 19/19] u14-34f: Add scsi_cmd_get_serial() call
Date: Mon, 27 Sep 2010 19:08:21 -0700
Message-Id: <1285639701-7585-1-git-send-email-nab@linux-iscsi.org>
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

