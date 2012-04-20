Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2DTU4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:56:34 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37848 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab2DTU4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:56:31 -0400
From: mathieu.poirier@linaro.org
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 7/8] sungem: use mdelay instead of udelay where necessary
Date: Fri, 20 Apr 2012 14:56:15 -0600
Message-Id: <1334955376-17793-8-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334955376-17793-1-git-send-email-mathieu.poirier@linaro.org>
References: <1334955376-17793-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Some architectures like ARM cannot handle large numbers as
arguments to udelay, so the drivers should use mdelay when
delaying for multiple miliseconds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/net/ethernet/sun/sungem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 558409f..26c1a2c 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -401,7 +401,7 @@ static int gem_rxmac_reset(struct gem *gp)
 		return 1;
 	}
 
-	udelay(5000);
+	mdelay(5);
 
 	/* Execute RX reset command. */
 	writel(gp->swrst_base | GREG_SWRST_RXRST,
-- 
1.7.5.4

