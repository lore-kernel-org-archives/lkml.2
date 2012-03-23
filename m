Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab2CWRPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:15:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53297 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2CWROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:14:11 -0400
From: mathieu.poirier@linaro.org
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 5/9] tty/serial/omap: console can only be built-in
Date: Fri, 23 Mar 2012 11:13:52 -0600
Message-Id: <1332522836-29517-6-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When the omap serial driver is built as a module, we must
not allow the console driver to be selected, because consoles
can not be loadable modules.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Govindraj.R <govindraj.raja@ti.com>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 2de9924..bcf7e24 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1041,7 +1041,7 @@ config SERIAL_OMAP
 
 config SERIAL_OMAP_CONSOLE
 	bool "Console on OMAP serial port"
-	depends on SERIAL_OMAP
+	depends on SERIAL_OMAP=y
 	select SERIAL_CORE_CONSOLE
 	help
 	  Select this option if you would like to use omap serial port as
-- 
1.7.5.4

