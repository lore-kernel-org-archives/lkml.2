Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310Ab1KJEZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:25:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62060 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965086Ab1KJEZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 23:25:04 -0500
Message-ID: <1320899091.6118.0.camel@phoenix>
Subject: [PATCH] Input: htcpen - add #ifdef CONFIG_PNP guard for pnp_ids
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pau Oliva Fora <pof@eslack.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Date: Thu, 10 Nov 2011 12:24:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build warning if CONFIG_PNP is disabled.

  CC      drivers/input/touchscreen/htcpen.o
drivers/input/touchscreen/htcpen.c:50: warning: 'pnp_ids' defined but not used

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/htcpen.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
index 62811de..7acc928 100644
--- a/drivers/input/touchscreen/htcpen.c
+++ b/drivers/input/touchscreen/htcpen.c
@@ -47,11 +47,13 @@ static int invert_y;
 module_param(invert_y, bool, 0644);
 MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
 
+#ifdef CONFIG_PNP
 static struct pnp_device_id pnp_ids[] = {
 	{ .id = "PNP0cc0" },
 	{ .id = "" }
 };
 MODULE_DEVICE_TABLE(pnp, pnp_ids);
+#endif
 
 static irqreturn_t htcpen_interrupt(int irq, void *handle)
 {
-- 
1.7.5.4



