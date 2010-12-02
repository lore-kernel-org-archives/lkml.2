Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab0LBOHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:07:37 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:39526 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757621Ab0LBOHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:07:36 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: ab8500-core interrupt ffs bit bug
Date: Thu, 2 Dec 2010 15:06:49 +0100
Message-ID: <1291298809-3275-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in ab8500 interrupt handling

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index dbe1c93..d9640a6 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -303,7 +303,7 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 			continue;
 
 		do {
-			int bit = __ffs(status);
+			int bit = __ffs(value);
 			int line = i * 8 + bit;
 
 			handle_nested_irq(ab8500->irq_base + line);
-- 
1.7.2.2

