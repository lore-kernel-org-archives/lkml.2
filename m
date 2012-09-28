Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab2I1Uhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:37:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60349 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759191Ab2I1Ugr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:36:47 -0400
X-Sasl-enc: Q2AH/ZKRRDRpCYndoIODPXHbWhgoatP2AZjg/mOstsKC 1348864606
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 192/218] pch_uart: Fix parity setting issue
Date: Fri, 28 Sep 2012 13:16:49 -0700
Message-Id: <20120928201523.602231920@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1357,7 +1357,7 @@ static void pch_uart_set_termios(struct
 		stb = PCH_UART_HAL_STB1;
 
 	if (termios->c_cflag & PARENB) {
-		if (!(termios->c_cflag & PARODD))
+		if (termios->c_cflag & PARODD)
 			parity = PCH_UART_HAL_PARITY_ODD;
 		else
 			parity = PCH_UART_HAL_PARITY_EVEN;


