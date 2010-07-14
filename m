Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0GNJRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:17:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64383 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0GNJRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:17:50 -0400
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] atmel_nand: Fix warning: 'part_probes' defined but not used
Date: Wed, 14 Jul 2010 11:17:06 +0200
Message-Id: <1279099026-24298-1-git-send-email-biessmann@corscience.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:yinQ5bPc9eZsmmeeY5L3FmyNMK0l2CpHAdiAr93edQ0
 t04N6Ho3Dr3zgCE4kHqxWPCOHgH9m9pJW+Hc5PBGHXQnfChihf
 APqBzi9RWnbBZT7VaS6VCBxXdnELghuno7FbgbbKLknRoW1qsW
 Opqz9j8yLwxhjpIo7uQcMwSxEsCqjuvLJ7M8s0yfzsV+5tjHuN
 1P7odz2T8Ciu59fC5OzlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes

drivers/mtd/nand/atmel_nand.c:372: warning: 'part_probes' defined but not used

which is issued when CONFIG_MTD_PARTITIONS is defined but
CONFIG_MTD_CMDLINE_PARTS not.

Signed-off-by: Andreas Bießmann <biessmann@corscience.de>
---
 drivers/mtd/nand/atmel_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 04d3088..ccce0f0 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -364,7 +364,7 @@ static void atmel_nand_hwctl(struct mtd_info *mtd, int mode)
 	}
 }
 
-#ifdef CONFIG_MTD_PARTITIONS
+#ifdef CONFIG_MTD_CMDLINE_PARTS
 static const char *part_probes[] = { "cmdlinepart", NULL };
 #endif
 
-- 
1.7.1

