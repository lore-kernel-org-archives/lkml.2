Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2GFITl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:19:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2GFITb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:19:31 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/2] pch_uart: Fix parity setting issue
Date: Fri,  6 Jul 2012 17:19:43 +0900
Message-Id: <1341562783-5571-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1341562783-5571-1-git-send-email-tomoya.rohm@gmail.com>
References: <1341562783-5571-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parity Setting value is reverse.
E.G. In case of setting ODD parity, EVEN value is set.
This patch inverts "if" condition.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4d84ad0..2911866 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1364,7 +1364,7 @@ static void pch_uart_set_termios(struct uart_port *port,
 		stb = PCH_UART_HAL_STB1;
 
 	if (termios->c_cflag & PARENB) {
-		if (!(termios->c_cflag & PARODD))
+		if (termios->c_cflag & PARODD)
 			parity = PCH_UART_HAL_PARITY_ODD;
 		else
 			parity = PCH_UART_HAL_PARITY_EVEN;
-- 
1.7.4.4

