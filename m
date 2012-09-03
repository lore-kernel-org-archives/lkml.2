Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab2ICLAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:00:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43881 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2ICLAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:00:12 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH] lib/dma-debug: check for vmalloc buffers used with the DMA-API
Date: Mon,  3 Sep 2012 13:00:04 +0200
Message-Id: <1346670004-10248-1-git-send-email-jlu@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:99ff:fe56:8d7
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
I'm not sure why we don't check for high memory, is there any problem
with this approach?

 lib/dma-debug.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 66ce414..7d60ff0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -944,6 +944,9 @@ static void check_for_illegal_area(struct device *dev, void *addr, unsigned long
 	if (overlap(addr, len, _text, _etext) ||
 	    overlap(addr, len, __start_rodata, __end_rodata))
 		err_printk(dev, NULL, "DMA-API: device driver maps memory from kernel text or rodata [addr=%p] [len=%lu]\n", addr, len);
+	if (is_vmalloc_or_module_addr(addr) ||
+	    is_vmalloc_or_module_addr(addr+len))
+		err_printk(dev, NULL, "DMA-API: device driver maps memory from vmalloc or module address range [addr=%p] [len=%lu]\n", addr, len);
 }
 
 static void check_sync(struct device *dev,
-- 
1.7.10.4

