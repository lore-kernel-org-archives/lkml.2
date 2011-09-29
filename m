Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1I2URd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:17:33 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:53982 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757493Ab1I2URc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:17:32 -0400
Message-ID: <4E84D259.5020008@xenotime.net>
Date: Thu, 29 Sep 2011 13:17:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andres Salomon <dilinger@debian.org>, x86 maintainers <x86@kernel.org>
Subject: [PATCH] olpc: olpc-xo1-sci.c is an input driver, depends on INPUT
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
In-Reply-To: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors when CONFIG_INPUT is disabled (shortened list):

olpc-xo1-sci.c:(.text+0x1aee6): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1b077): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.text+0x1b081): undefined reference to `input_free_device'
arch/x86/built-in.o:olpc-xo1-sci.c:(.text+0x1b270): more undefined references to `input_event' follow
olpc-xo1-sci.c:(.devinit.text+0x155): undefined reference to `input_allocate_device'
olpc-xo1-sci.c:(.devinit.text+0x1a4): undefined reference to `input_register_device'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andres Salomon <dilinger@debian.org>
---
Found in linux-next but also applies to mainline.

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-2011-0929.orig/arch/x86/Kconfig
+++ next-2011-0929/arch/x86/Kconfig
@@ -2052,7 +2052,7 @@ config OLPC_XO1_RTC
 
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
-	depends on OLPC && OLPC_XO1_PM
+	depends on OLPC && OLPC_XO1_PM && INPUT
 	select POWER_SUPPLY
 	select GPIO_CS5535
 	select MFD_CORE
