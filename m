Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab1DNOn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:43:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64472 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab1DNOn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:43:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=tdXrZbBBXeJmtOqJ5R3wzNvuFN7xi8NBsp86xPMaEPvacMGWqd1eSgcEmuLY9NCG9D
         W9/wkrCVaBU5LxP+uL22f1SFHfP1m/vu66Y0/1npIgkB+foGXMHvurLnawpok0t9Jeju
         1KvioyxR/nrRzIyjON0GOu4yLukq2dimqbRbA=
Subject: [PATCH] mfd: asic3: Fix build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 22:43:47 +0800
Message-ID: <1302792227.8637.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below compile error:

  CC      drivers/mfd/asic3.o
drivers/mfd/asic3.c: In function 'asic3_irq_demux':
drivers/mfd/asic3.c:147: error: 'irq_data' undeclared (first use in this function)
drivers/mfd/asic3.c:147: error: (Each undeclared identifier is reported only once
drivers/mfd/asic3.c:147: error: for each function it appears in.)

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/asic3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 0536e11..77a3971 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -144,7 +144,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 	int iter, i;
 	unsigned long flags;
 
-	data->chip->irq_ack(irq_data);
+	data->chip->irq_ack(data);
 
 	for (iter = 0 ; iter < MAX_ASIC_ISR_LOOPS; iter++) {
 		u32 status;
-- 
1.7.1



