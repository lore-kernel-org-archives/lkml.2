Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2CZF2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:28:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43670 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2CZF2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:28:41 -0400
Message-ID: <1332739713.15735.1.camel@phoenix>
Subject: [PATCH] watchdog: Make TXX9_WDT select WATCHDOG_CORE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Ralf Baechle <ralf@linux-mips.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Date: Mon, 26 Mar 2012 13:28:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required after converting to watchdog core API.

Fix below build errors:
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `txx9wdt_probe':
txx9wdt.c:(.init.text+0x3530): undefined reference to `watchdog_register_device'
drivers/built-in.o: In function `txx9wdt_remove':
txx9wdt.c:(.exit.text+0x158): undefined reference to `watchdog_unregister_device'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I have this change in my source tree but forgot to add it when
generating the patch converting txx9_wdt to watchdog framework.

 drivers/watchdog/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index f5b1ec6..3709624 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1003,6 +1003,7 @@ config AR7_WDT
 config TXX9_WDT
 	tristate "Toshiba TXx9 Watchdog Timer"
 	depends on CPU_TX39XX || CPU_TX49XX
+	select WATCHDOG_CORE
 	help
 	  Hardware driver for the built-in watchdog timer on TXx9 MIPS SoCs.
 
-- 
1.7.5.4



