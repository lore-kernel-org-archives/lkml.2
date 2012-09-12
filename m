Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032Ab2ILSOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:14:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57327 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760946Ab2ILSOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:14:12 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <khilman@ti.com>, <nsekhar@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH] davinci: check for presence of channel controller on slot alloc
Date: Wed, 12 Sep 2012 14:14:02 -0400
Message-ID: <1347473642-9948-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check for the presence of the channel controller when
trying to allocate a slot.  Without this fix, the kernel panics with a NULL
pointer dereference when the dma-engine drivers are probed.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/dma.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-davinci/dma.c b/arch/arm/mach-davinci/dma.c
index a685e97..2fee31e 100644
--- a/arch/arm/mach-davinci/dma.c
+++ b/arch/arm/mach-davinci/dma.c
@@ -743,6 +743,9 @@ EXPORT_SYMBOL(edma_free_channel);
  */
 int edma_alloc_slot(unsigned ctlr, int slot)
 {
+	if (!edma_cc[ctlr])
+		return -ENODEV;
+
 	if (slot >= 0)
 		slot = EDMA_CHAN_SLOT(slot);
 
-- 
1.7.9.5

