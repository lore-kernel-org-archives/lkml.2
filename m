Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0C1L2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:28:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48210 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0C1L2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Izomk1CnL0nmhO/WLdtWHCmXutmkpw37iIj/ABdUwA5Z0x7eQq24Lq46wRMQppwCrI
         nvnoCfG9VO4/jWesyLxAQRp6nC6AdiHAao4J5Vw6FAuIovzAl1tv6XxmRMN+f8Hkh2sx
         U0/qudGMPdSj801ZL/RLG7LPqrodQ5eSDkz4Q=
Date: Sun, 28 Mar 2010 14:28:08 +0300
From: Dan Carpenter <error27@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Fertser <fercerpav@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Arnaud Patard <arnaud.patard@rtp-net.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] mfd: off by one issue
Message-ID: <20100328112808.GO5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"pcf->irq_handler" has PCF50633_NUM_IRQ elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 03dcc92..4f13608 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -217,7 +217,7 @@ static struct attribute_group pcf_attr_group = {
 int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
 			void (*handler) (int, void *), void *data)
 {
-	if (irq < 0 || irq > PCF50633_NUM_IRQ || !handler)
+	if (irq < 0 || irq >= PCF50633_NUM_IRQ || !handler)
 		return -EINVAL;
 
 	if (WARN_ON(pcf->irq_handler[irq].handler))
@@ -234,7 +234,7 @@ EXPORT_SYMBOL_GPL(pcf50633_register_irq);
 
 int pcf50633_free_irq(struct pcf50633 *pcf, int irq)
 {
-	if (irq < 0 || irq > PCF50633_NUM_IRQ)
+	if (irq < 0 || irq >= PCF50633_NUM_IRQ)
 		return -EINVAL;
 
 	mutex_lock(&pcf->lock);
