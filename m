Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030661Ab2I1TF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:05:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030646Ab2I1TFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:05:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 236/262] pch_uart: Fix parity setting issue
Date: Fri, 28 Sep 2012 11:52:45 -0700
Message-Id: <20120928183026.245674048@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 38bd2a1ac736901d1cf4971c78ef952ba92ef78b upstream.

Parity Setting value is reverse.
E.G. In case of setting ODD parity, EVEN value is set.
This patch inverts "if" condition.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/pch_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1365,7 +1365,7 @@ static void pch_uart_set_termios(struct
 		stb = PCH_UART_HAL_STB1;
 
 	if (termios->c_cflag & PARENB) {
-		if (!(termios->c_cflag & PARODD))
+		if (termios->c_cflag & PARODD)
 			parity = PCH_UART_HAL_PARITY_ODD;
 		else
 			parity = PCH_UART_HAL_PARITY_EVEN;


