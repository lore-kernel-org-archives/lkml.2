Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab0I1CIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:08:23 -0400
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:34471 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932157Ab0I1CIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:08:19 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: iq6o82MVM1mStIQmL54Oq0b3ZPEYqgjBGld2cvTvxO0gTk7
 GDAH6.SXUdcTf1mGo0Q_d8GXpBgF7Mw5oSN1WtYAmlCPclFWCdSlVS.zvt2m
 4XVUGTmsdgmgeEd0UrrkuQEsMn7p8D49vaiP31iJRgOsv.9d87fRAQgM3z8m
 pi4J8msTslWKKn_EZr6t6CWKVH3IC.yG1TYQIGZkJGCNd_1fjIeyDDovh2fz
 vwS3t5Lnx9qB5j0xDepZASAcyUk42Gl2mrcyp82YWVJWOaaxHLmzhVVB8Ipz
 6NoLDhpEqxSmTHkvFIBrHfOCCRh.hFcwgvNtWti.VU5qFvkJT.JlTj6MkuRo
 sB9jcg3MNfsx9XpqwZ.30tYZOEccZRlDOUyTbEirhy7F8yl.kebfA7xg7oB1
 Zymb3PpIEiS7iw5cdzs9faKZAgjCwEbVBOF9MC42j
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
Subject: [RFC v4 18/19] eata: Add scsi_cmd_get_serial() call
Date: Mon, 27 Sep 2010 19:08:11 -0700
Message-Id: <1285639691-7565-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in eata2x_queuecommand()
to setup a valid struct scsi_cmnd->serial_number because ihdlr() still
depends upon this being set.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/eata.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index d1c3137..e56a0d7 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1765,6 +1765,11 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 	unsigned int i, k;
 	struct mscp *cpp;
+        /*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * for the main eata interrupt handler in ihdlr()
+	 */
+        scsi_cmd_get_serial(SCpnt);
 
 	if (SCpnt->host_scribble)
 		panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
-- 
1.7.3

