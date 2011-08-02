Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1HBL0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:26:38 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:59061 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1HBL0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:26:33 -0400
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [BUGFIX][PATCH] Fix double inversion bug in clk_disable()
Date: Tue,  2 Aug 2011 13:26:30 +0200
Message-Id: <1312284390-20244-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The condition check for calling the low level disable function is
wrong due to double inversion via '!' and '== 0'.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/clk/clk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 83c6b67..1525e2a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -81,7 +81,7 @@ void clk_disable(struct clk *clk)
 
 	WARN_ON(clk->enable_count == 0);
 
-	if (!--clk->enable_count == 0 && clk->ops->disable)
+	if (--clk->enable_count == 0 && clk->ops->disable)
 		clk->ops->disable(clk);
 
 	spin_unlock_irqrestore(&clk->enable_lock, flags);
-- 
1.5.6.5

