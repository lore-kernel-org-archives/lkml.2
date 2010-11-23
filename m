Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0KWLGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:06:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39485 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0KWLGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:06:21 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jamie Iles <jamie.iles@picochip.com>
Subject: [PATCH 1/4] dmaengine/dw_dmac: don't scan descriptors if no xfers in progress
Date: Tue, 23 Nov 2010 11:06:08 +0000
Message-Id: <1290510371-23077-2-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware (picoChip picoXCell in particular) sometimes has
the block transfer complete bit being set for a channel after the
whole transfer has completed. If we don't have any transfers in the
active list then don't bother to scan the descriptors. This often
happens in normal operation and doesn't require the channel to be
reset.

Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
---
 drivers/dma/dw_dmac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a3991ab..08c51d4 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -291,6 +291,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		return;
 	}
 
+        if (list_empty(&dwc->active_list))
+                return;
+
 	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%x\n", llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
-- 
1.7.2.3

