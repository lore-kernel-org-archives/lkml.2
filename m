Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab1FWS25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:28:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:63022 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab1FWRWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 026/247] staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card
Date: Thu, 23 Jun 2011 13:17:49 -0400
Message-Id: <1308849690-14530-27-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d1ce318496f5943d2cc5e20171fc383a59a1421f upstream.

The ni_labpc driver module only requests a shared IRQ for PCI devices,
requesting a non-shared IRQ for non-PCI devices.
As this module is also used by the ni_labpc_cs module for certain
National Instruments PCMCIA cards, it also needs to request a shared IRQ
for PCMCIA devices, otherwise you get a IRQ mismatch with the CardBus
controller.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 558e525..3f4fbfe 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -572,7 +572,8 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	/* grab our IRQ */
 	if (irq) {
 		isr_flags = 0;
-		if (thisboard->bustype == pci_bustype)
+		if (thisboard->bustype == pci_bustype
+		    || thisboard->bustype == pcmcia_bustype)
 			isr_flags |= IRQF_SHARED;
 		if (request_irq(irq, labpc_interrupt, isr_flags,
 				driver_labpc.driver_name, dev)) {
-- 
1.7.4.4

