Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2INVkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:40:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab2INVfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 20/24] input: rpcmouse: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:48 +0200
Message-Id: <1347658492-11608-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QSv4Ths/yb92LBwmOZdzA0sjn1or97u6IlrVSjT+rdT
 HhUrAaV4l1PHLihCw5X4UwoiKxuI1jQSMetr1b+uWcy4w0n+pu
 R1/e+hf/T82hsYqjV7oIgAX4rELHfiudw7xaejrzYZW5O/0/Sv
 ZH0FImJn9TYh5FgKKhc5LMu8n98H/OR407R6hrQul1BrKFm43b
 CFQK7QMrvNGZvnftf+9h/DL/dKGMiiDfbIldV5sPY4Q3N5Tgcj
 YTh8EhoY/DUk+NvLKYvcH79Na9FnP8ZRt4weM254oxX3OrqRtT
 XPgm9QQ0I6foR8jLPcoK8ro9vhiZcN5dmw3Nw9fmuWSeUQBD4v
 ghUeOIEx7mFwuDTIBD6pcUYIVd1lRVFOyKMfl8fZ68eCpBV5i4
 h5bB8ocoBCYBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/input/mouse/rpcmouse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/rpcmouse.c b/drivers/input/mouse/rpcmouse.c
index 272dedd..21c60fe 100644
--- a/drivers/input/mouse/rpcmouse.c
+++ b/drivers/input/mouse/rpcmouse.c
@@ -42,7 +42,7 @@ static irqreturn_t rpcmouse_irq(int irq, void *dev_id)
 
 	x = (short) iomd_readl(IOMD_MOUSEX);
 	y = (short) iomd_readl(IOMD_MOUSEY);
-	b = (short) (__raw_readl(0xe0310000) ^ 0x70);
+	b = (short) (__raw_readl(IOMEM(0xe0310000)) ^ 0x70);
 
 	dx = x - rpcmouse_lastx;
 	dy = y - rpcmouse_lasty;
-- 
1.7.10

