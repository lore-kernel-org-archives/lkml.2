Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0LBRUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:20:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28158 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab0LBRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:20:48 -0500
Date: Thu, 2 Dec 2010 09:19:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>, gregkh@suse.de,
        akpm <akpm@linux-foundation.org>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH -next] serial: fix pch_uart kconfig & build
Message-Id: <20101202091948.2142bb5c.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTi=aZ3Gm5rkqAh8j-bOvvKULge6Hm5cN_mEovVdq@mail.gmail.com>
References: <20101202140943.c9742beb.sfr@canb.auug.org.au>
	<AANLkTi=aZ3Gm5rkqAh8j-bOvvKULge6Hm5cN_mEovVdq@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
---
 drivers/serial/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

This driver seems to have some other issues:

drivers/serial/pch_uart.c: In function 'dma_handle_rx':
drivers/serial/pch_uart.c:685: warning: cast from pointer to integer of different size
drivers/serial/pch_uart.c: In function 'dma_handle_tx':
drivers/serial/pch_uart.c:778: warning: cast from pointer to integer of different size
drivers/serial/pch_uart.c: In function 'pch_uart_init_port':
drivers/serial/pch_uart.c:1289: warning: cast to pointer from integer of different size
drivers/serial/pch_uart.c: In function 'pch_uart_exit_port':
drivers/serial/pch_uart.c:1328: warning: cast from pointer to integer of different size

--- linux-next-20101202.orig/drivers/serial/Kconfig
+++ linux-next-20101202/drivers/serial/Kconfig
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
