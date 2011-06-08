Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1FHNVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:21:03 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:22133 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab1FHNVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:21:01 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v4 0/6] [PATCH v4 0/6] GPIO: pca953x.c: Fix IRQ support and OF device-tree bindings
Date: Wed,  8 Jun 2011 14:48:28 +0200
Message-Id: <1307537314-4345-1-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes IRQ support and cleans up OF device-tree support for
the PCA953X gpio driver.
This is version 4 of the patch series, after receiving feedback from
Grant Likely and Thomas Gleixner.

Changes in this version:
 - Call irq_alloc_descs unconditionally to allocate IRQ descriptors.
 - Instead of adding linux,irq-base to OF bindings, remove all of them, since
   they are not needed. IRQ's are allocated dynamically by irq_alloc_descs
   (pdata->irq_base may still be specified by platform setup code, to set a
   base for searching).
 - For CONFIG_OF_GPIO, pdata->irq_base is set to -1 to disable GPIO-interrupt
   support, if the "interrupts" property is not specified in the I2C
   device-node.
 - On suggestion from Grant Likely, changed IRQF_TRIGGER_FALLING to
   IRQF_TRIGGER_LOW to enable the driver to share the physical interrupt line,
   and better reflect the actual working of the pin (active-low interrupt).
 - Split-out the patches a bit more.

David Jander (6):
  GPIO: pca953x.c: Fix IRQ support.
  GPIO: pca953x.c: Set device platform_data pointer after allocating it
  GPIO: pca953x.c: Remove meaningless device-tree bindings
  GPIO: pca953x.c: Interrupt pin is active-low
  GPIO: pca953x.c: Fix warning of enabled interrupts in handler
  GPIO: pca953x.c: Add missing irq_mask_ack handler in struct irq_chip

 drivers/gpio/pca953x.c |   79 +++++++++++++----------------------------------
 1 files changed, 22 insertions(+), 57 deletions(-)

-- 
1.7.4.1

