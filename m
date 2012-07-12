Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134Ab2GLMYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:24:00 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:48209 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754728Ab2GLMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:23:58 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        linux-mtd@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ARM: LPC32xx: Adjust to pl08x DMA interface changes
Date: Thu, 12 Jul 2012 14:22:55 +0200
Message-Id: <1342095778-13403-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the LPC32xx platform support to the new pl08x DMA interface,
fixing the compile error resulting from changed pl08x structures.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to today's linux-next (integrated lpc32xx-next and dma branches which collide)

 arch/arm/mach-lpc32xx/phy3250.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index 8625237..b07dcc9 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -186,13 +186,12 @@ static struct pl08x_channel_data pl08x_slave_channels[] = {
 	},
 };
 
-/* NOTE: These will change, according to RMK */
-static int pl08x_get_signal(struct pl08x_dma_chan *ch)
+static int pl08x_get_signal(const struct pl08x_channel_data *cd)
 {
-	return ch->cd->min_signal;
+	return cd->min_signal;
 }
 
-static void pl08x_put_signal(struct pl08x_dma_chan *ch)
+static void pl08x_put_signal(const struct pl08x_channel_data *cd, int ch)
 {
 }
 
-- 
1.7.10.4

