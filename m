Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994Ab2INVfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:35:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab2INVfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 21/24] serial: ks8695: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:49 +0200
Message-Id: <1347658492-11608-22-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:URW70d2nAKAwMxiDiMNXVdeLFnSZLWM5hPl2ttyV3tp
 PkF13eZpWvG97+b5WnHqjuk2lYdLMYidR24oYh5F0d+wph+FJT
 qUwUGlByPCwELhq/2upbr+g621dCW3RcKqPlrpbfWHNlztW1bC
 IG+DgX910dSYAojqOUNbBoAjx+OH+wUyislbgP5mvtp5L+n26T
 BhM7qy3OhcvwBzxA4U/sdl/5dzw3TEBRhwL61Fyd2vPY+/vHm2
 0+/ynEI9isNKRMox3TEziGbhuL1f7opEyVhXFWdg7gB2EwrDA7
 rmpkCAAasbdNYWlJeBp3jla4d23dXTxvD36eWe0zftkQnhx2yq
 XaOmtiYB201y/UpK3gIuCCyhu/SQgY74lDyb3hEBF8Armu68Vs
 L22Frar5td+aQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/tty/serial/serial_ks8695.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_ks8695.c b/drivers/tty/serial/serial_ks8695.c
index 7c13639..9bd004f 100644
--- a/drivers/tty/serial/serial_ks8695.c
+++ b/drivers/tty/serial/serial_ks8695.c
@@ -548,8 +548,8 @@ static struct uart_ops ks8695uart_pops = {
 
 static struct uart_port ks8695uart_ports[SERIAL_KS8695_NR] = {
 	{
-		.membase	= (void *) KS8695_UART_VA,
-		.mapbase	= KS8695_UART_VA,
+		.membase	= KS8695_UART_VA,
+		.mapbase	= KS8695_UART_PA,
 		.iotype		= SERIAL_IO_MEM,
 		.irq		= KS8695_IRQ_UART_TX,
 		.uartclk	= KS8695_CLOCK_RATE * 16,
-- 
1.7.10

