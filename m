Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1HBHHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:07:21 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:62728 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1HBHHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:07:18 -0400
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] disable the correct parent clock in clk_gate_disable()
Date: Tue,  2 Aug 2011 09:07:15 +0200
Message-Id: <1312268835-32291-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling clk_parent_disable() on the parent clock goes one step too far
up the clock hierarchy.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/clk/clk-gate.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index a10d8e3..712960a 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -90,9 +90,7 @@ static void clk_gate_disable(struct clk *clk)
 	struct clk_gate *gate = to_clk_gate(clk);
 
 	gate->disable(gate);
-
-	if (gate->parent)
-		clk_parent_disable(gate->parent);
+	clk_parent_disable(clk);
 }
 
 static struct clk *clk_gate_get_parent(struct clk *clk)
-- 
1.5.6.5

