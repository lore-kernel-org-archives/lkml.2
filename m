Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3AGFJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:09:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60643 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3AGFJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:09:57 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sekhar Nori <nsekhar@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH 02/10] video: da8xx-fb: enable sync lost intr for v2 ip
Date: Mon, 7 Jan 2013 10:40:41 +0530
Message-ID: <f7099dbc7a1262690d26b062e72bcbd08954c07e.1357304090.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357304090.git.afzal@ti.com>
References: <cover.1357304090.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interrupt handler is checking for sync lost interrupt, but it was not
enabled, enable it.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index cd73b87..4f92028 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -322,7 +322,7 @@ static void lcd_blit(int load_mode, struct da8xx_fb_par *par)
 			reg_int = lcdc_read(LCD_INT_ENABLE_SET_REG) |
 				LCD_V2_END_OF_FRAME0_INT_ENA |
 				LCD_V2_END_OF_FRAME1_INT_ENA |
-				LCD_FRAME_DONE;
+				LCD_FRAME_DONE | LCD_SYNC_LOST;
 			lcdc_write(reg_int, LCD_INT_ENABLE_SET_REG);
 		}
 		reg_dma |= LCD_DUAL_FRAME_BUFFER_ENABLE;
-- 
1.7.9.5

