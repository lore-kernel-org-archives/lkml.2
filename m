Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1JBOsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:48:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58505 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab1JBOq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Govindraj.R" <govindraj.raja@ti.com>
Subject: [PATCH 19/30] tty/serial/omap: console can only be built-in
Date: Sun,  2 Oct 2011 16:45:49 +0200
Message-Id: <1317566760-25681-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:lBnGotq7c9344U4+zDkDyPwdP17S13+3wmOfsKyHtIe
 cLvdt5lYIS5el4v0NuBUV1WgHtIwsJvKmeveDDLViqcObgRmct
 nnFdg0MWYaryDWOPNJL0b3xciA4KeED5rtv9B9nTwkdZOCvj2W
 AHQ/1dAARjYhx8ItVIZAdtrAquTwjTc9gaowT01c+SSQvotouX
 6REIcpZT606t1FpEDQvrn7ZiJiJmxphxEUYR5Z0hfAka8MC1SM
 Bt4LHrW8TnWsZDU0aWlVzaNDZgBdOoW5WQ61WzHXMSTRgBPdyn
 yGDt+e5M1YD+ckOatbAwKTtNPOlZulFkgDoIKYC11f9E3Qv2CY
 wlnnnB4sxtyE2ncIzxtX0880d0jnWZC+99dC6ZxWzLEtKCabFR
 Ek0Eggo/YWK6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the omap serial driver is built as a module, we must
not allow the console driver to be selected, because consoles
can not be loadable modules.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Govindraj.R <govindraj.raja@ti.com>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 4dcb37bb..eb04b2f 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1346,7 +1346,7 @@ config SERIAL_OMAP
 
 config SERIAL_OMAP_CONSOLE
 	bool "Console on OMAP serial port"
-	depends on SERIAL_OMAP
+	depends on SERIAL_OMAP=y
 	select SERIAL_CORE_CONSOLE
 	help
 	  Select this option if you would like to use omap serial port as
-- 
1.7.5.4

