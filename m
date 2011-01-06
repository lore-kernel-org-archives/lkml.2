Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1AFWXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:23:54 -0500
Received: from kroah.org ([198.145.64.141]:55677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1AFWXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/36] serial: fix pch_uart kconfig & build
Date: Thu,  6 Jan 2011 14:23:11 -0800
Message-Id: <1294352605-31906-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The dma_request_channel/dma_release_channel interfaces are not
built when DMADEVICES is not enabled, so make the driver depend on
DMADEVICES.  Also, the help text says that the driver enables & uses
PCH_DMA, which is not enabled, so select that.

ERROR: "__dma_request_channel" [drivers/serial/pch_uart.ko] undefined!
ERROR: "dma_release_channel" [drivers/serial/pch_uart.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Reported-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index fa02904..ec3c214 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1650,8 +1650,9 @@ config SERIAL_IFX6X60
 
 config SERIAL_PCH_UART
 	tristate "Intel EG20T PCH UART"
+	depends on PCI && DMADEVICES
 	select SERIAL_CORE
-	depends on PCI
+	select PCH_DMA
 	help
 	  This driver is for PCH(Platform controller Hub) UART of Intel EG20T
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
-- 
1.7.3.2

