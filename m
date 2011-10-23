Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1JWVSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:18:23 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:49861 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1JWVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:18:20 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/5] m68k/scsi: Remove obsolete IRQ_FLG_* users
Date: Sun, 23 Oct 2011 23:18:03 +0200
Message-Id: <1319404686-10800-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319404686-10800-1-git-send-email-geert@linux-m68k.org>
References: <1319404686-10800-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m68k core irq code stopped honoring these flags during the irq
restructuring in 2006.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
This is a split-up of "m68k/irq: Remove obsolete IRQ_FLG_* definitions and
users", to reduce conflicts and dependencies.

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index af3a6af..ea2bde2 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -291,8 +291,7 @@ int __init macscsi_detect(struct scsi_host_template * tpnt)
     ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
 
     if (instance->irq != SCSI_IRQ_NONE)
-	if (request_irq(instance->irq, NCR5380_intr, IRQ_FLG_SLOW, 
-			"ncr5380", instance)) {
+	if (request_irq(instance->irq, NCR5380_intr, 0, "ncr5380", instance)) {
 	    printk(KERN_WARNING "scsi%d: IRQ%d not free, interrupts disabled\n",
 		   instance->host_no, instance->irq);
 	    instance->irq = SCSI_IRQ_NONE;
