Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab2HVPQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:16:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52772 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab2HVPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:16:36 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Wed, 22 Aug 2012 10:16:30 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] media/radio/shark2: Fix build error caused by missing dependencies
Date: Wed, 22 Aug 2012 08:16:25 -0700
Message-Id: <1345648585-5176-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error:

ERROR: "led_classdev_register" [drivers/media/radio/shark2.ko] undefined!
ERROR: "led_classdev_unregister" [drivers/media/radio/shark2.ko] undefined!

which is seen if RADIO_SHARK2 is enabled, but LEDS_CLASS is not.

Since RADIO_SHARK2 depends on NEW_LEDS and LEDS_CLASS, select both if
it is enabled.

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/media/radio/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 8090b87..bee4bee 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -77,6 +77,8 @@ config RADIO_SHARK
 config RADIO_SHARK2
 	tristate "Griffin radioSHARK2 USB radio receiver"
 	depends on USB
+	select NEW_LEDS
+	select LEDS_CLASS
 	---help---
 	  Choose Y here if you have this radio receiver.
 
-- 
1.7.9.7

