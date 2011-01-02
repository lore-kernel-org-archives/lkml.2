Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1ABMlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 07:41:49 -0500
Received: from mail-ew0-f66.google.com ([209.85.215.66]:36443 "EHLO
	mail-ew0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1ABMkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 07:40:35 -0500
Message-ID: <4d207240.cc7e0e0a.6f59.3765@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Sun, 2 Jan 2011 14:07:00 +0200
Subject: [PATCH 8/9 v2] cx23885: disable MSI for NetUP cards, otherwise CI is not working
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/cx23885-core.c |    4 ++++
 drivers/media/video/cx23885/cx23885-reg.h  |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 3a09dd2..e6d7232 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1039,6 +1039,10 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 
 	cx23885_dev_checkrevision(dev);
 
+	/* disable MSI for NetUP cards, otherwise CI is not working */
+	if (cx23885_boards[dev->board].ci_type > 0)
+		cx_clear(RDR_RDRCTL1, 1 << 8);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/cx23885/cx23885-reg.h b/drivers/media/video/cx23885/cx23885-reg.h
index a28772d..c87ac68 100644
--- a/drivers/media/video/cx23885/cx23885-reg.h
+++ b/drivers/media/video/cx23885/cx23885-reg.h
@@ -292,6 +292,7 @@ Channel manager Data Structure entry = 20 DWORD
 #define RDR_CFG0	0x00050000
 #define RDR_CFG1	0x00050004
 #define RDR_CFG2	0x00050008
+#define RDR_RDRCTL1	0x0005030c
 #define RDR_TLCTL0	0x00050318
 
 /* APB DMAC Current Buffer Pointer */
-- 
1.7.1

