Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0INW0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:26:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31560 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab0INWZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:25:59 -0400
Date: Tue, 14 Sep 2010 15:23:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: cx25821 and go7007 depend on IR_CORE
Message-Id: <20100914152359.f871d000.randy.dunlap@oracle.com>
In-Reply-To: <20100914135802.c99d3672.sfr@canb.auug.org.au>
References: <20100914135802.c99d3672.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors in cx25821 and go7007.
They both use IR functions, so they should depend on IR_CORE.
(It's not safe to select VIDEO_IR when IR_CORE is not enabled.)

(.text+0x39065a): undefined reference to `ir_core_debug'
(.text+0x3906a4): undefined reference to `ir_core_debug'
ir-functions.c:(.text+0x39080b): undefined reference to `ir_core_debug'
(.text+0x390893): undefined reference to `ir_g_keycode_from_table'
(.text+0x390942): undefined reference to `ir_core_debug'
(.text+0x3909f5): undefined reference to `ir_core_debug'
(.text+0x390a3a): undefined reference to `ir_core_debug'
(.text+0x390ab1): undefined reference to `ir_core_debug'
(.text+0x390b36): undefined reference to `ir_core_debug'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/cx25821/Kconfig |    2 +-
 drivers/staging/go7007/Kconfig  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20100914.orig/drivers/staging/cx25821/Kconfig
+++ linux-next-20100914/drivers/staging/cx25821/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
-	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TVEEPROM
--- linux-next-20100914.orig/drivers/staging/go7007/Kconfig
+++ linux-next-20100914/drivers/staging/go7007/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
-	depends on VIDEO_DEV && PCI && I2C && INPUT
+	depends on VIDEO_DEV && PCI && I2C && INPUT && IR_CORE
 	depends on SND
 	select VIDEOBUF_DMA_SG
 	select VIDEO_IR
