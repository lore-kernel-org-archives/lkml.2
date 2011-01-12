Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab1ALC7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 21:59:19 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:27627 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756190Ab1ALC7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 21:59:13 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 2/2] pch_uart: revert Kconfig for non-DMA mode
Date: Wed, 12 Jan 2011 11:58:50 +0900
Message-Id: <1294801130-3912-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294801130-3912-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1294801130-3912-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCH_DMA is not always enabled when a user uses PCH_UART.
Since overhead of DMA is not small, in case of low frequent communication,
without DMA is better.
Thus, "select PCH_DMA" and DMADEVICES are unnecessary

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/serial/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 3d836f0..58847e9 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1587,10 +1587,9 @@ config SERIAL_IFX6X60
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
 config SERIAL_PCH_UART
-	tristate "Intel EG20T PCH UART"
-	depends on PCI && DMADEVICES
+	tristate "Intel EG20T PCH UART/OKI SEMICONDUCTOR ML7213 IOH"
+	depends on PCI
 	select SERIAL_CORE
-	select PCH_DMA
 	help
 	  This driver is for PCH(Platform controller Hub) UART of Intel EG20T
 	  which is an IOH(Input/Output Hub) for x86 embedded processor.
-- 
1.6.2.5

