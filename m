Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab2BBVdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:33:40 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57332 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab2BBVdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:33:37 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 10/11] usb/renesas: add context parameter to prep_slave_sg call
Date: Thu,  2 Feb 2012 16:32:20 -0500
Message-Id: <1328218341-31436-11-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup for calls affected by adding the new context parameter to DMA_SLAVE
interface.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/renesas_usbhs/fifo.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 72339bd..089622f 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -785,7 +785,8 @@ static void usbhsf_dma_prepare_tasklet(unsigned long data)
 
 	desc = chan->device->device_prep_slave_sg(chan, &sg, 1, dir,
 						  DMA_PREP_INTERRUPT |
-						  DMA_CTRL_ACK);
+						  DMA_CTRL_ACK,
+						  NULL);
 	if (!desc)
 		return;
 
-- 
1.7.8.4

