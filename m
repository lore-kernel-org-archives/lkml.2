Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1LSPiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:38:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46188 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1LSPiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:38:06 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, FlorianSchandinat@gmx.de,
        Marek Vasut <marek.vasut@gmail.com>, Wolfgang Denk <wd@denx.de>,
        Stefano Babic <sbabic@denx.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>, Axel Lin <axel.lin@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH RESEND] MXSFB: Fix driver registration
Date: Mon, 19 Dec 2011 16:37:59 +0100
Message-Id: <1324309079-10739-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver should be registered with mxsfb_driver, not with mxsfb_devtype.
This caused obvious null pointer dereference and crash.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Cc: Wolfgang Denk <wd@denx.de>
Cc: Stefano Babic <sbabic@denx.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Huang Shijie <b32955@freescale.com>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/video/mxsfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 18742c2..d29c7c0 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -902,7 +902,7 @@ static struct platform_driver mxsfb_driver = {
 	},
 };
 
-module_platform_driver(mxsfb_devtype);
+module_platform_driver(mxsfb_driver);
 
 MODULE_DESCRIPTION("Freescale mxs framebuffer driver");
 MODULE_AUTHOR("Sascha Hauer, Pengutronix");
-- 
1.7.6.4

