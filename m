Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2A3QEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:04:35 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:53605 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753387Ab2A3QCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:02:55 -0500
From: Roland Stigge <stigge@antcom.de>
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 5/7] LPC32xx: clock.c: warning fix
Date: Mon, 30 Jan 2012 17:02:04 +0100
Message-Id: <1327939327-7799-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327939327-7799-1-git-send-email-stigge@antcom.de>
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the debug warning on local_clk_disable() as done in Kevin
Wells' driver update

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index 229bec5..01e9aba 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -903,8 +903,6 @@ static inline void clk_unlock(void)
 
 static void local_clk_disable(struct clk *clk)
 {
-	WARN_ON(clk->usecount == 0);
-
 	/* Don't attempt to disable clock if it has no users */
 	if (clk->usecount > 0) {
 		clk->usecount--;
