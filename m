Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0KTMBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 07:01:40 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:46017 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0KTMBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 07:01:39 -0500
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] backlight: make 1-bit signed filed unsigned in l4f00242t03.c
Date: Sat, 20 Nov 2010 13:01:24 +0100
Message-Id: <1290254484-12141-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on
	Spam=No score=-1.4 bayes=0.5
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warning:
drivers/video/backlight/l4f00242t03.c:28:21: error: dubious one-bit
signed bitfield

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 drivers/video/backlight/l4f00242t03.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index c67801e..6d9ba0e 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -25,7 +25,7 @@
 struct l4f00242t03_priv {
 	struct spi_device	*spi;
 	struct lcd_device	*ld;
-	int lcd_on:1;
+	unsigned int lcd_on:1;
 	struct regulator *io_reg;
 	struct regulator *core_reg;
 };
-- 
1.7.0.4

