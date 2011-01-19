Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1ASIlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:41:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62713 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1ASIlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:41:23 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        "Govindraj.R" <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] OMAP: Enable Magic SysRq on serial console ttyOx
Date: Wed, 19 Jan 2011 09:41:01 +0100
Message-Id: <1295426461-12459-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
X-Provags-ID: V02:K0:wuKfrrLDyg0triebSfDb7AKOqO4BCN34+cSvz7RFs/J
 C+7Tt5WaeaaA7tDJnkpXb3y5wW0c6axwn9LYajrnLRpTfzzujt
 Pd0m5sNAbJmbpni6Dy/4Ecf/3jTy1GXPagJAlCzGPWFuDCa9nd
 v9FLdfMsG1pUnNeJoJX9WZgh32uiqQj0dTkvRgms0bAM14Zu7p
 /THCm6WuJR9L654s2tmpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magic SysRq key is not working for OMAP on new serial
console ttyOx because SUPPORT_SYSRQ is not defined
for omap-serial.

This patch defines SUPPORT_SYSRQ in omap-serial and
enables handling of Magic SysRq character.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
Changes from v1: Changed comment

 drivers/serial/omap-serial.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
index 1201eff..907be9b 100644
--- a/drivers/serial/omap-serial.c
+++ b/drivers/serial/omap-serial.c
@@ -20,6 +20,10 @@
  * this driver as required for the omap-platform.
  */
 
+#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/console.h>
-- 
1.7.4.rc2

