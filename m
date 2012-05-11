Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab2EKXhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:37:10 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:57623 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754567Ab2EKXhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:37:08 -0400
Message-ID: <4FADA2B2.8070302@xenotime.net>
Date: Fri, 11 May 2012 16:37:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH -next] via_wdt: depends on PCI
References: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au>
In-Reply-To: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

via_wdt is a PCI driver so it should depend on PCI so that
it will not cause build errors.

drivers/watchdog/via_wdt.c:256:1: warning: data definition has no type or storage class
drivers/watchdog/via_wdt.c:256:1: warning: type defaults to 'int' in declaration of 'module_pci_driver'
drivers/watchdog/via_wdt.c:256:1: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/watchdog/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120511.orig/drivers/watchdog/Kconfig
+++ linux-next-20120511/drivers/watchdog/Kconfig
@@ -788,7 +788,7 @@ config SMSC37B787_WDT
 
 config VIA_WDT
 	tristate "VIA Watchdog Timer"
-	depends on X86
+	depends on X86 && PCI
 	select WATCHDOG_CORE
 	---help---
 	This is the driver for the hardware watchdog timer on VIA
