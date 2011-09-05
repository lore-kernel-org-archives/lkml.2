Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1IETKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:10:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48270 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1IETJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:09:56 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: [PATCH 1/2] leds-class: change back LEDS_CLASS to tristate instead of bool
Date: Tue,  6 Sep 2011 03:09:45 +0800
Message-Id: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LEDS_CLASS is required by leds and trigger drivers, but we can build it
as module. So change this option back as tristate and treak the help
message as well.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/Kconfig |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index b591e72..1c35927 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -17,10 +17,13 @@ menuconfig NEW_LEDS
 if NEW_LEDS
 
 config LEDS_CLASS
-	bool "LED Class Support"
+	tristate "LED Class Support"
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
-	  need this to do anything useful with LEDs.  If unsure, say N.
+	  need this to do anything useful with LEDs.  If unsure, say M.
+
+	  Note: don't disable it as N, because plenty of led and trigger drivers
+	  are using this option.
 
 comment "LED drivers"
 
-- 
1.7.4.1

