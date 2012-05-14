Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2ENUOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:14:20 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:51509 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932323Ab2ENUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:14:18 -0400
Message-ID: <4FB167A5.9010905@xenotime.net>
Date: Mon, 14 May 2012 13:14:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH -next] wdt: ie6xx_wdt needs io.h
References: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au>
In-Reply-To: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error by including <linux/io.h>:

drivers/watchdog/ie6xx_wdt.c:97:2: error: implicit declaration of function 'outb'
drivers/watchdog/ie6xx_wdt.c:133:2: error: implicit declaration of function 'outl'
drivers/watchdog/ie6xx_wdt.c:161:2: error: implicit declaration of function 'inb'
drivers/watchdog/ie6xx_wdt.c:199:3: error: implicit declaration of function 'inl'
drivers/watchdog/ie6xx_wdt.c:203:3: error: implicit declaration of function 'inw'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/ie6xx_wdt.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20120514.orig/drivers/watchdog/ie6xx_wdt.c
+++ linux-next-20120514/drivers/watchdog/ie6xx_wdt.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
