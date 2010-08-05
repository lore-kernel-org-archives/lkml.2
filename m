Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab0HEJTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:19:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52368 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab0HEJTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oRiDZL93J3yaR+8qEeXRwh+2GYxxuH8giu0UArPH5Onq+MAtu6sksDo01mKztb1vj8
         Jy+Rl9UyHxFD59ytCaUUU3s2w68WAhUCeYkN7rgiBohUAjFPtfdRSx8wj4g0KorzzP3p
         ZTo582X+lYpYew8iVpHG4PJStOigW4fJJMyKA=
From: Eric Miao <eric.y.miao@gmail.com>
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, stable <stable@kernel.org>
Subject: [PATCH] w100fb: fix building error caused by incorrect use of writel()
Date: Thu,  5 Aug 2010 17:19:34 +0800
Message-Id: <1280999974-2585-1-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Cc: stable <stable@kernel.org>
---
 drivers/video/w100fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index e66b8b1..d8b12c3 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -858,9 +858,9 @@ unsigned long w100fb_gpio_read(int port)
 void w100fb_gpio_write(int port, unsigned long value)
 {
 	if (port==W100_GPIO_PORT_A)
-		value = writel(value, remapped_regs + mmGPIO_DATA);
+		writel(value, remapped_regs + mmGPIO_DATA);
 	else
-		value = writel(value, remapped_regs + mmGPIO_DATA2);
+		writel(value, remapped_regs + mmGPIO_DATA2);
 }
 EXPORT_SYMBOL(w100fb_gpio_read);
 EXPORT_SYMBOL(w100fb_gpio_write);
-- 
1.7.1

