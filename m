Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab2K0ESt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:18:49 -0500
Received: from mail-gg0-f202.google.com ([209.85.161.202]:65161 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab2K0ESr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:18:47 -0500
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        benchan@chromium.org
Subject: [PATCH] staging: gdm72xx: fix unused variable warning in gdm_usb_send
Date: Mon, 26 Nov 2012 20:18:45 -0800
Message-Id: <1353989925-17533-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an unused variable warning in gdm_usb_send
(when CONFIG_WIMAX_GDM72XX_K_MODE=n), which was introduced in
commit 1a276b80466bbd195cf94ec7178f68f2ab351467 (staging:
gdm72xx: protect access of rx / tx structs).

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_usb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 4426941..3709824 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -316,7 +316,10 @@ static int gdm_usb_send(void *priv_dev, void *data, int len,
 	int no_spc = 0, ret;
 	u8 *pkt = data;
 	u16 cmd_evt;
-	unsigned long flags, flags2;
+	unsigned long flags;
+#ifdef CONFIG_WIMAX_GDM72XX_K_MODE
+	unsigned long flags2;
+#endif /* CONFIG_WIMAX_GDM72XX_K_MODE */
 
 	if (!udev->usbdev) {
 		dev_err(&usbdev->dev, "%s: No such device\n", __func__);
-- 
1.7.7.3

