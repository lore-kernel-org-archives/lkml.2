Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1AUOMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:12:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43047 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1AUOMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:12:15 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Dan Williams <dan.j.williams@intel.com>,
        Jamie Iles <jamie.iles@picochip.com>
Subject: [PATCH repost 1/4] dmaengine/dw_dmac: don't scan descriptors if no xfers in progress
Date: Fri, 21 Jan 2011 14:11:52 +0000
Message-Id: <1295619115-18420-2-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware (picoChip picoXCell in particular) sometimes has
the block transfer complete bit being set for a channel after the
whole transfer has completed. If we don't have any transfers in the
active list then don't bother to scan the descriptors. This often
happens in normal operation and doesn't require the channel to be
reset.

v2: cleanup whitespace

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
---
 drivers/dma/dw_dmac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a3991ab..db22754 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -291,6 +291,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		return;
 	}
 
+	if (list_empty(&dwc->active_list))
+		return;
+
 	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%x\n", llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
-- 
1.7.3.4

