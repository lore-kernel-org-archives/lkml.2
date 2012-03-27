Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2C0DQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 23:16:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65310 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab2C0DQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 23:16:03 -0400
Message-ID: <1332818156.21855.4.camel@phoenix>
Subject: [PATCH] video: pxa3xx-gcu: Simplify the logic to exit while loop in
 pxa3xx_gcu_wait_idle
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Sven Neumann <s.neumann@raumfeld.com>,
        Janine Kropp <nin@directfb.org>, Denis Oliver Kropp <dok@directfb.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Date: Tue, 27 Mar 2012 11:15:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If wait_event_interruptible_timeout returns a positive value, it means
the condition evaluated is true. Which means priv->shared->hw_running is false.
And then we will exit the loop.

This patch simplifies the logic to exit the while loop.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/pxa3xx-gcu.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/video/pxa3xx-gcu.c b/drivers/video/pxa3xx-gcu.c
index 1d71c08..0b4ae0c 100644
--- a/drivers/video/pxa3xx-gcu.c
+++ b/drivers/video/pxa3xx-gcu.c
@@ -316,12 +316,9 @@ pxa3xx_gcu_wait_idle(struct pxa3xx_gcu_priv *priv)
 		ret = wait_event_interruptible_timeout(priv->wait_idle,
 					!priv->shared->hw_running, HZ*4);
 
-		if (ret < 0)
+		if (ret != 0)
 			break;
 
-		if (ret > 0)
-			continue;
-
 		if (gc_readl(priv, REG_GCRBEXHR) == rbexhr &&
 		    priv->shared->num_interrupts == num) {
 			QERROR("TIMEOUT");
-- 
1.7.5.4



