Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2CWFl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 01:41:58 -0400
Received: from fw2.prolan.hu ([193.68.50.107]:41731 "EHLO fw2.prolan.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab2CWFl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 01:41:56 -0400
Message-ID: <4F6B4C11.4000608@prolan.hu>
Date: Thu, 22 Mar 2012 16:58:09 +0100
From: Peter Rusko <rusko.peter@prolan.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>
Subject: PCA GPIO interrupt triggers
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.91.83.115]
X-EsetResult: clean, is OK
X-EsetId: 525F3323825E3531001F6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using a GPIO chip (PCA9554) for a matrix-keypad. The keypad driver 
itself needs interrupts for both rising and falling edges. The PCA 
driver (gpio-pca953x.c) doesn't support it, but I don't understand why.

I think, this patch should work:

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 147df8a..be9aff4 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -356,12 +356,6 @@ static int pca953x_irq_set_type(struct irq_data *d, 
unsigned int type)
         uint16_t level = d->irq - chip->irq_base;
         uint16_t mask = 1 << level;

-       if (!(type & IRQ_TYPE_EDGE_BOTH)) {
-               dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
-                       d->irq, type);
-               return -EINVAL;
-       }
-
         if (type & IRQ_TYPE_EDGE_FALLING)
                 chip->irq_trig_fall |= mask;
         else

I think that the other parts of the code checks for rising and falling 
edges correctly. Am I missing something?

-- 
Ruskó Péter
Fejlesztőmérnök

Prolan Zrt. / Prolan Co.
Hungary 2011 Budakalász, Szentendrei út 1-3.
Tel./Phone: +36 20 954 3118
Fax: +36 26 540 420
E-mail: rusko.peter@prolan.hu
Web: www.prolan.hu
Timezone:CET
