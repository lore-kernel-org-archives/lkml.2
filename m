Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab1GOGUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:20:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36036 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab1GOGUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:20:07 -0400
Subject: [PATCH 02/16] SCSI: NCR53c406a: Remove Scsi_Cmnd
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave@gnu.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 15 Jul 2011 02:19:43 -0400
Message-ID: <1310710783.3184.53.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/NCR53c406a.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index c91888a..62e0aaf 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -201,7 +201,7 @@ static int dma_chan;
 static int fast_pio = USE_FAST_PIO;
 #endif
 
-static Scsi_Cmnd *current_SC;
+static struct scsi_cmnd *current_SC;
 static char info_msg[256];
 
 /* ================================================================= */
@@ -693,7 +693,7 @@ static void wait_intr(void)
 }
 #endif
 
-static int NCR53c406a_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int NCR53c406a_queue_lck(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	int i;
 
@@ -728,7 +728,7 @@ static int NCR53c406a_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 
 static DEF_SCSI_QCMD(NCR53c406a_queue)
 
-static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
+static int NCR53c406a_host_reset(struct scsi_cmnd * SCpnt)
 {
 	DEB(printk("NCR53c406a_reset called\n"));
 
-- 
1.7.4.1





