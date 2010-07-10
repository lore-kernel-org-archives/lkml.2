Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0GJV1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:27:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53014 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0GJV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ncXZZI3ALsSE53E8Ru19h1dI/qSjUnR/UvKcDb2FVCKDWwWD7RWwJ80TiHCp4zRWs4
         ftpOpYpeeCQtkA+Oh/sqBOlgiRH9M3MY9ZCfikldasNzvFEB5iMj3rYAQ2dMdSkH+nqk
         5XOFNBudoHY93rJWXttwlJBKErIO1/sTcdf7w=
From: Zachary Richey <zr.public@gmail.com>
To: isdn@linux-pingi.de, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Richey <zr.public@gmail.com>
Subject: [PATCH] Drivers: isdn: Fixed warnings and odd code.
Date: Sat, 10 Jul 2010 17:27:29 -0400
Message-Id: <c40325e3d4cdc2f8c196b57c8581a0656828187c.1278796499.git.zr.public@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes compile time warnings in drivers/isdn/sc/init.c, and
also cleans up what looked like redundant code in this file.
Signed-off-by: Zachary Richey <zr.public@gmail.com>
---
 drivers/isdn/sc/init.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index ca710ab..1255995 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -484,27 +484,18 @@ static int identify_board(unsigned long rambase, unsigned int iobase)
 	 */
 	outb(PRI_BASEPG_VAL, pgport);
 	msleep_interruptible(1000);
-	sig = readl(rambase + SIG_OFFSET);
+	sig = readl(&rambase + SIG_OFFSET);
 	pr_debug("Looking for a signature, got 0x%lx\n", sig);
-	if(sig == SIGNATURE)
+	if (sig == SIGNATURE)
 		return PRI_BOARD;
-
-	/*
-	 * Try to identify a PRI card
-	 */
-	outb(BRI_BASEPG_VAL, pgport);
-	msleep_interruptible(1000);
-	sig = readl(rambase + SIG_OFFSET);
-	pr_debug("Looking for a signature, got 0x%lx\n", sig);
-	if(sig == SIGNATURE)
+	if (sig == SIGNATURE)
 		return BRI_BOARD;
-
 	return -1;
 
 	/*
 	 * Try to spot a card
 	 */
-	sig = readl(rambase + SIG_OFFSET);
+	sig = readl(&rambase + SIG_OFFSET);
 	pr_debug("Looking for a signature, got 0x%lx\n", sig);
 	if(sig != SIGNATURE)
 		return -1;
-- 
1.7.0.4

