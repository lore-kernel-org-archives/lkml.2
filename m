Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1DTUAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:00:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36784 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab1DTUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=iYmoGfV5LJEWXPr+rDL1tJGubsEdsqFJJfM4TSuf4+WrSn2Vz60O+UJ77gsrJt/Gl/
         HpL7dliCIOh2Edsl1+UOoMHzZFs3UZFZRMz1N90Gd71w/TgW10ftXUKe3K9tzmFNRSie
         52f0ytQfMPCE70UETkKciV4LPnu/sXfzF8vzk=
Subject: [PATCH] mfd: asic3: fix build breakage from 52a7d607
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 20 Apr 2011 22:00:27 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0- 
Content-Transfer-Encoding: 7bit
Message-ID: <1303329628.21545.10.camel@flow>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct irq_data pointer is called data, not irq_data.
Also, use irq_data_get_chip() instead of data->chip directly.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index d4a851c..05a9c9d 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -144,7 +144,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 	int iter, i;
 	unsigned long flags;
 
-	data->chip->irq_ack(irq_data);
+	irq_data_get_irq_chip(data)->irq_ack(data);
 
 	for (iter = 0 ; iter < MAX_ASIC_ISR_LOOPS; iter++) {
 		u32 status;
-- 
1.7.4.4


