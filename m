Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab2HFEP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:15:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54857 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2HFEPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:15:25 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 05 Aug 2012 23:15:24 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guenter Roeck <linux@roeck-us.net>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] Add USB dependency for IguanaWorks USB IR Transceiver
Date: Sun,  5 Aug 2012 21:15:20 -0700
Message-Id: <1344226520-22318-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the error
	drivers/usb/core/hub.c:3753: undefined reference to `usb_speed_string'
seen in various random configurations.

Cc: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/media/rc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 5180390..8be5763 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -261,6 +261,7 @@ config IR_WINBOND_CIR
 
 config IR_IGUANA
 	tristate "IguanaWorks USB IR Transceiver"
+	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
 	---help---
-- 
1.7.9.7

