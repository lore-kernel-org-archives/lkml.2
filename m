Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0IWXpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:45:40 -0400
Received: from nm9.bullet.mail.ne1.yahoo.com ([98.138.90.72]:37080 "HELO
	nm9.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755039Ab0IWXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:45:39 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 19:45:39 EDT
X-Yahoo-Newman-Id: 551609.52989.bm@omp1028.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Ybx6GMIVM1loxYUeHfB9mfCDcMyN138gPB5.Fuk_d154OiN
 hk_WW5zBj4wC_IIt3_SDLquwDKeTazCy76BiLHss99nYFBo8U2OOVaudSgt5
 dNnR1uT4K.3xnIIPTe_f.bcWxb9QQ2BgOe3dq2ypUBbSqUMEdMy6r9q9AtOP
 rgv0z2FQvHHBpQ0A4mL9QYBWiMyGeOd5BvZdI7vqXo7fWfnhKUNBeovRyYch
 U9JxmmPVO9MLbtjJ1cyPqwSfA9jE7T5x1TyIS3L8LWeFgDzoAsEflRkBUCRw
 xd8zwQUN0jxgUSUlZBH9nhmcJbZOGaHDwuhgD3.niXZaGc9frT5GAj2ht4e9
 t5qjbwvUvTNWjv.I26g--
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
Subject: [RFC v3 12/15] mpt/fusion: Add scsi_cmd_get_serial() call
Date: Thu, 23 Sep 2010 16:39:12 -0700
Message-Id: <1285285152-16586-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in mptscsih_qcmd() to setup a
valid struct scsi_cmnd->serial_number because mptscsih_abort() still depends
upon this being set.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/message/fusion/mptscsih.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 59b8f53..6aaa553 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1411,6 +1411,11 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
 	SCpnt->scsi_done = done;
+	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * in mptscsih_abort()
+	 */
+	scsi_cmd_get_serial(SCpnt);
 
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
 		ioc->name, SCpnt, done));
-- 
1.7.3

