Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2EHHSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:18:54 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:37488 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab2EHHSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:18:51 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: leoli@freescale.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 2/2] usb: fsl_mxc_udc.c: fix mxc_ahb_clk disable for i.MX25
Date: Tue,  8 May 2012 09:18:30 +0200
Message-Id: <1336461510-30190-2-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336461510-30190-1-git-send-email-eric@eukrea.com>
References: <1336461510-30190-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as i.MX35, i.MX25 doesn't have this clock so don't try to disable/put it.

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 drivers/usb/gadget/fsl_mxc_udc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/fsl_mxc_udc.c b/drivers/usb/gadget/fsl_mxc_udc.c
index 8bbf673..4e30fb6 100644
--- a/drivers/usb/gadget/fsl_mxc_udc.c
+++ b/drivers/usb/gadget/fsl_mxc_udc.c
@@ -78,10 +78,10 @@ eclkrate:
 	clk_put(mxc_usb_clk);
 	mxc_usb_clk = NULL;
 egusb:
-	if (!cpu_is_mx35())
+	if (!cpu_is_mx35() && !cpu_is_mx25())
 		clk_disable(mxc_ahb_clk);
 eenahb:
-	if (!cpu_is_mx35())
+	if (!cpu_is_mx35() && !cpu_is_mx25())
 		clk_put(mxc_ahb_clk);
 	return ret;
 }
@@ -120,7 +120,7 @@ void fsl_udc_clk_release(void)
 		clk_disable(mxc_usb_clk);
 		clk_put(mxc_usb_clk);
 	}
-	if (!cpu_is_mx35()) {
+	if (!cpu_is_mx35() && !cpu_is_mx25()) {
 		clk_disable(mxc_ahb_clk);
 		clk_put(mxc_ahb_clk);
 	}
-- 
1.7.7.6

