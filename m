Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1EYFTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:19:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54856 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1EYFTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Ot2+ghnlJ7z0jUf9ehXxT8EJZeu9gN2H2M/JKlgmhZoK+hXMGNiTbivma1U6o/4Ro/
         Kj9A6fZg5xvl3Yx1U4scSXuubTXMlZhKQt0013KCdI9/UQoDMH7XkKOK1fJikkoENg/D
         WxcxWYg0x/yd3LUYPDhwdxV2RKaRCT9nrstME=
Subject: [PATCH] leds: leds-asic3: make LEDS_ASIC3 depend on LEDS_CLASS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Parsons <lost.distance@yahoo.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 13:19:40 +0800
Message-ID: <1306300780.20042.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call led_classdev_unregister/led_classdev_register in
asic3_led_remove/asic3_led_probe, thus make LEDS_ASIC3 depend on LEDS_CLASS.

This patch fixes below build error if LEDS_CLASS is not configured.

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `asic3_led_remove':
clkdev.c:(.devexit.text+0x1860): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `asic3_led_probe':
clkdev.c:(.devinit.text+0xcee8): undefined reference to `led_classdev_register'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 4a40561..cb8562a 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -381,6 +381,7 @@ config LEDS_NETXBIG
 
 config LEDS_ASIC3
 	bool "LED support for the HTC ASIC3"
+	depends on LEDS_CLASS
 	depends on MFD_ASIC3
 	default y
 	help
-- 
1.7.1



