Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033126Ab2I1VT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:19:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52036 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759267Ab2I1UiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:24 -0400
X-Sasl-enc: gZMoO2X/79IYogmRWFMPigeCm3pDolPRJsdYAuxrA1ma 1348864703
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        dcb314@hotmail.com, Alan Cox <alan@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 190/218] pch_uart: Fix missing break for 16 byte fifo
Date: Fri, 28 Sep 2012 13:16:47 -0700
Message-Id: <20120928201523.344433158@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 9bc03743fff0770dc5a5324ba92e67cc377f16ca upstream.

Otherwise we fall back to the wrong value.

Reported-by: <dcb314@hotmail.com>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44091
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/pch_uart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1255,6 +1255,7 @@ static int pch_uart_startup(struct uart_
 		break;
 	case 16:
 		fifo_size = PCH_UART_HAL_FIFO16;
+		break;
 	case 1:
 	default:
 		fifo_size = PCH_UART_HAL_FIFO_DIS;


