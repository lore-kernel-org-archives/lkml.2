Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1FBFJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:09:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61482 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1FBFJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SWAJgf0uPEOuRszuRMERx/ZoV0V1/u4EAoeoQYDDmn6a54tAU0mND0v06BtrNgrbvT
         PP3AuUSmEVmzrT2SJcCViB1qcQslp5RCWYrkgj9sss1jYzhnrIj3J+AK6OTD6Q2yMHIf
         yE2LxpyMaL3JqWxmIVMpeeEzofdfNwAoj0YY4=
From: Eric Miao <eric.y.miao@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: Eric Miao <eric.miao@linaro.org>, Eric Miao <eric.miao@canonical.com>,
        Eric Miao <eric.y.miao@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] leds: fix the menuconfig being wrongly displayed
Date: Thu,  2 Jun 2011 13:09:14 +0800
Message-Id: <1306991354-11890-1-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@canonical.com>

Seems when a config option does not have a dependency of the menuconfig,
it messes the display of the rest configs, even if it's a hidden one.

Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 23f0d5e..7066820 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -7,6 +7,8 @@ menuconfig NEW_LEDS
 	  This is not related to standard keyboard LEDs which are controlled
 	  via the input system.
 
+if NEW_LEDS
+
 config LEDS_CLASS
 	bool "LED Class Support"
 	depends on NEW_LEDS
@@ -21,8 +23,6 @@ config LEDS_GPIO_REGISTER
 	  As this function is used by arch code it must not be compiled as a
 	  module.
 
-if NEW_LEDS
-
 comment "LED drivers"
 
 config LEDS_88PM860X
-- 
1.7.4.1

