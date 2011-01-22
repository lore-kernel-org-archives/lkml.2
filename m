Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1AVBId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:08:33 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:34609 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1AVBIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:08:32 -0500
Date: Sat, 22 Jan 2011 02:08:30 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Molton <ian@mnementh.co.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: Fix ASIC3 build with GENERIC_HARDIRQS_NO_DEPRECATED
Message-ID: <20110122010830.GK23596@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 6a1f940..c45e630 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -143,9 +143,9 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 	unsigned long flags;
 	struct asic3 *asic;
 
-	desc->chip->ack(irq);
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	asic = desc->handler_data;
+	asic = get_irq_data(irq);
 
 	for (iter = 0 ; iter < MAX_ASIC_ISR_LOOPS; iter++) {
 		u32 status;
--
