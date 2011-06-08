Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1FHNVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:21:44 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:22137 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab1FHNVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:21:02 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v4 4/6] GPIO: pca953x.c: Interrupt pin is active-low
Date: Wed,  8 Jun 2011 14:48:32 +0200
Message-Id: <1307537314-4345-5-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307537314-4345-1-git-send-email-david@protonic.nl>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt pin of the PCA953x is active low, and on the rising edge
no interrupt should be produced.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/gpio/pca953x.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index ae9fe61..97e0d32 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -496,8 +496,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		ret = request_threaded_irq(client->irq,
 					   NULL,
 					   pca953x_irq_handler,
-					   IRQF_TRIGGER_RISING |
-					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 					   dev_name(&client->dev), chip);
 		if (ret) {
 			dev_err(&client->dev, "failed to request irq %d\n",
-- 
1.7.4.1

