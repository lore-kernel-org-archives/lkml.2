Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1AKMqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:46:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab1AKMon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:43 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org
Subject: [PATCH 10/16] drivers/net: stmmac: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:47 +0000
Message-Id: <1294749833-32019-11-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/net/stmmac/stmmac_timer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/stmmac/stmmac_timer.c b/drivers/net/stmmac/stmmac_timer.c
index 2a0e1ab..ebb1b37 100644
--- a/drivers/net/stmmac/stmmac_timer.c
+++ b/drivers/net/stmmac/stmmac_timer.c
@@ -91,6 +91,7 @@ int stmmac_close_ext_timer(void)
 
 #elif defined(CONFIG_STMMAC_TMU_TIMER)
 #include <linux/clk.h>
+#include <linux/err.h>
 #define TMU_CHANNEL "tmu2_clk"
 static struct clk *timer_clock;
 
@@ -109,7 +110,7 @@ int stmmac_open_ext_timer(struct net_device *dev, struct stmmac_timer *tm)
 {
 	timer_clock = clk_get(NULL, TMU_CHANNEL);
 
-	if (timer_clock == NULL)
+	if (IS_ERR(timer_clock))
 		return -1;
 
 	if (tmu2_register_user(stmmac_timer_handler, (void *)dev) < 0) {
-- 
1.7.3.4

