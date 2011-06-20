Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1FTL0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:26:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35035 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753151Ab1FTL0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:26:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Ensure value written by wm831x_set_bits() is within the mask
Date: Mon, 20 Jun 2011 12:25:58 +0100
Message-Id: <1308569158-22484-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Purely for defensiveness.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 02c9109..6c53376 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -260,7 +260,7 @@ int wm831x_set_bits(struct wm831x *wm831x, unsigned short reg,
 		goto out;
 
 	r &= ~mask;
-	r |= val;
+	r |= val & mask;
 
 	ret = wm831x_write(wm831x, reg, 2, &r);
 
-- 
1.7.5.4

