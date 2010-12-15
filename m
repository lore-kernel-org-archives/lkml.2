Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab0LOKun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:50:43 -0500
Received: from mail.atmel.fr ([81.80.104.162]:43386 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0LOKum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:50:42 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MTD: m25p80: add debugging trace in sst_write()
Date: Wed, 15 Dec 2010 12:59:32 +0100
Message-Id: <1292414372-17085-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DEBUG(MTD_DEBUG_LEVEL2, ..) trace at beginning of sst_write() function as
it is done in m25p80_write() function.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mtd/devices/m25p80.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index bf5a002..e6b5707 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -482,6 +482,10 @@ static int sst_write(struct mtd_info *mtd, loff_t to, size_t len,
 	size_t actual;
 	int cmd_sz, ret;
 
+	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
+			dev_name(&flash->spi->dev), __func__, "to",
+			(u32)to, len);
+
 	*retlen = 0;
 
 	/* sanity checks */
-- 
1.7.3

