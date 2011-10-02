Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1JBOsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:48:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1JBOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 16/30] usb/musb: HDRC depends on TWL4030_CORE for OMAP3/4
Date: Sun,  2 Oct 2011 16:45:46 +0200
Message-Id: <1317566760-25681-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1x7mgt/y4ZC51jNm2uON3H/rs0WUpOHkIbwRcK4Foo/
 YllCBmB0lsA55zOz+R5e/7hzcVCZBFMcxscr4DE/+ZK5ooc7qn
 UuufVN4WjNeKJqEaBpDMJM4kzK7w2ALUnS4oQSat+2BMpsQk6b
 QYspVnrZKHHJ+t9rrWW5kSjk1eo01soIx2AR4H1mtXjuPMYZO1
 oSZ9TFa/4IMDhU0n85Xh6D4Ip1YikGo2BsFge6C4WRWAi3yZ6R
 ejslKb2midfDqqvkzGUDY1/9wpfQg5Op++M15ptZ3iKdGIXDag
 CShsrCQwzxf0haRHMYfPE4ZTvhC+mBbkaYa7RF+Ln42+OqMG8q
 ApWd6s3rqNnRAwXvvJaCU18+YRaDvkwAusOXbB7jdrfJ8AHREv
 DfjhSBBCxbm6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The musb_hdrc driver tries to select TWL4030_USB or TWL6030_USB
on some platforms, but those symbols in turn depend on TWL4030_CORE.
Trying not to spread the 'select' further, this makes the driver
depend on the TWL4030_CORE for the platforms that do other selects.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/musb/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index d596fb2..b6732ee 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -7,6 +7,7 @@
 config USB_MUSB_HDRC
 	depends on USB && USB_GADGET
 	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
+	depends on TWL4030_CORE || !(MACH_OMAP_3430SDP || MACH_OMAP_4430SDP || MACH_OMAP4_PANDA)
 	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
-- 
1.7.5.4

