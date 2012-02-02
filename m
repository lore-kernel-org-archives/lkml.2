Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2BBVdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:33:35 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57314 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab2BBVdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:33:33 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/11] usb/musb: add context parameter to prep_slave_sg call
Date: Thu,  2 Feb 2012 16:32:19 -0500
Message-Id: <1328218341-31436-10-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixups for calls affected by adding the new context parameter to DMA_SLAVE
and DMA_CYCLIC interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/musb/ux500_dma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 97cb459..b3cd9a7 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -121,7 +121,8 @@ static bool ux500_configure_channel(struct dma_channel *channel,
 
 	dma_desc = dma_chan->device->
 			device_prep_slave_sg(dma_chan, &sg, 1, direction,
-					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+					     NULL);
 	if (!dma_desc)
 		return false;
 
-- 
1.7.8.4

