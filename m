Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0GLPPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:15:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38612 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0GLPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:15:49 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH 1/3] trivial: fix typos concerning "empty"
Date: Mon, 12 Jul 2010 17:15:44 +0200
Message-Id: <1278947746-11253-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 Documentation/scsi/ChangeLog.lpfc    |    2 +-
 arch/arm/plat-mxc/dma-mx1-mx2.c      |    2 +-
 drivers/scsi/aic7xxx_old/aic7xxx.seq |    2 +-
 drivers/serial/nwpserial.c           |    2 +-
 sound/usb/pcm.c                      |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/scsi/ChangeLog.lpfc
index e759e92..337c924 100644
--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -807,7 +807,7 @@ Changes from 20040908 to 20040920
 	  lpfc_disc_done/lpfc_do_dpc cleanup - lpfc_disc_done can return
 	  void - move lpfc_do_dpc and lpfc_disc_done to lpfc_hbadisc.c -
 	  remove checking of list emptiness before calling lpfc_disc_done,
-	  it handles the emtpy list case just fine and the additional
+	  it handles the empty list case just fine and the additional
 	  instructions cost less then the bustlocked spinlock operations.
 	* Integrated patch from Christoph Hellwig: This adds a new 64bit
 	  counter instead, brd_no isn't reused anymore.  Also some tiny
diff --git a/arch/arm/plat-mxc/dma-mx1-mx2.c b/arch/arm/plat-mxc/dma-mx1-mx2.c
index 3765ac0..68988af 100644
--- a/arch/arm/plat-mxc/dma-mx1-mx2.c
+++ b/arch/arm/plat-mxc/dma-mx1-mx2.c
@@ -310,7 +310,7 @@ imx_dma_setup_sg(int channel,
 	imxdma->resbytes = dma_length;
 
 	if (!sg || !sgcount) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg epty sg list\n",
+		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg empty sg list\n",
 		       channel);
 		return -EINVAL;
 	}
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.seq b/drivers/scsi/aic7xxx_old/aic7xxx.seq
index f6fc4b7..5997e7c 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx.seq
+++ b/drivers/scsi/aic7xxx_old/aic7xxx.seq
@@ -615,7 +615,7 @@ ultra2_dmafifoflush:
 			 * went empty and the next bit of data is copied from
 			 * the SCSI fifo into the PCI fifo.  It should only
 			 * come on when both FIFOs (meaning the entire FIFO
-			 * chain) are emtpy.  Since it can take up to 4 cycles
+			 * chain) are empty.  Since it can take up to 4 cycles
 			 * for new data to be copied from the SCSI fifo into
 			 * the PCI fifo, testing for FIFOEMP status for 4
 			 * extra times gives the needed time for any
diff --git a/drivers/serial/nwpserial.c b/drivers/serial/nwpserial.c
index 3c02fa9..e65b0d9 100644
--- a/drivers/serial/nwpserial.c
+++ b/drivers/serial/nwpserial.c
@@ -81,7 +81,7 @@ nwpserial_console_write(struct console *co, const char *s, unsigned int count)
 
 	uart_console_write(&up->port, s, count, nwpserial_console_putchar);
 
-	/* wait for transmitter to become emtpy */
+	/* wait for transmitter to become empty */
 	while ((dcr_read(up->dcr_host, UART_LSR) & UART_LSR_THRE) == 0)
 		cpu_relax();
 
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 4568298..3634ced 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -636,7 +636,7 @@ static int hw_rule_period_time(struct snd_pcm_hw_params *params,
 		min_datainterval = min(min_datainterval, fp->datainterval);
 	}
 	if (min_datainterval == 0xff) {
-		hwc_debug("  --> get emtpy\n");
+		hwc_debug("  --> get empty\n");
 		it->empty = 1;
 		return -EINVAL;
 	}
-- 
1.7.1

