Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab1FHNVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:21:06 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:22134 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab1FHNVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:21:01 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v4 6/6] GPIO: pca953x.c: Add missing irq_mask_ack handler in struct irq_chip
Date: Wed,  8 Jun 2011 14:48:34 +0200
Message-Id: <1307537314-4345-7-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307537314-4345-1-git-send-email-david@protonic.nl>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Either .irq_mask_ack or .irq_ack need to be filled in, otherwise in
kernel/irq/chip.c: mask_ack_irq() a non-initialized handler is called.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/gpio/pca953x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index dfed81f..b476c1c 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -379,6 +379,7 @@ static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
 static struct irq_chip pca953x_irq_chip = {
 	.name			= "pca953x",
 	.irq_mask		= pca953x_irq_mask,
+	.irq_mask_ack		= pca953x_irq_mask,
 	.irq_unmask		= pca953x_irq_unmask,
 	.irq_bus_lock		= pca953x_irq_bus_lock,
 	.irq_bus_sync_unlock	= pca953x_irq_bus_sync_unlock,
-- 
1.7.4.1

