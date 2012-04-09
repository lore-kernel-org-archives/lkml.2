Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab2DIUxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:53:33 -0400
Received: from mail.df.lth.se ([194.47.250.12]:19776 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758031Ab2DIUxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:53:31 -0400
From: "Linus Walleij" <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Alim Akhtar <alim.akhtar@gmail.com>
Subject: [PATCH 1/2] dma/amba-pl08x: check for terminal count status only
Date: Mon,  9 Apr 2012 22:53:21 +0200
Message-Id: <1334004801-20185-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason I can't figure out we're reading the PL080_INT_STATUS
register instead of PL080_TC_STATUS when checking for the terminal
count. The PL080_INT_STATUS is a logical OR between the error and
terminal count status register and may not report what we want it
to, especially if there is an error and a terminal count at the same
time and the former is not lowered in time for the check in the TC
register. Make sure we read what we're actually interested in.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Alim Akhtar <alim.akhtar@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index c301a8e..08589c6 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1615,7 +1615,7 @@ static irqreturn_t pl08x_irq(int irq, void *dev)
 			__func__, err);
 		writel(err, pl08x->base + PL080_ERR_CLEAR);
 	}
-	tc = readl(pl08x->base + PL080_INT_STATUS);
+	tc = readl(pl08x->base + PL080_TC_STATUS);
 	if (tc)
 		writel(tc, pl08x->base + PL080_TC_CLEAR);
 
-- 
1.7.7.6

