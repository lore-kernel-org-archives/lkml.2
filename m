Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161053Ab2I1UtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:49:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53008 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945944Ab2I1Usy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:54 -0400
X-Sasl-enc: t222iXmhA60QtDrnkxLHaVVVtPgPSKJsXIbaCNhANcjJ 1348865333
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        dcb314@hotmail.com, Alan Cox <alan@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 115/127] pch_uart: Fix missing break for 16 byte fifo
Date: Fri, 28 Sep 2012 13:34:48 -0700
Message-Id: <20120928203059.374756445@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1161,6 +1161,7 @@ static int pch_uart_startup(struct uart_
 		break;
 	case 16:
 		fifo_size = PCH_UART_HAL_FIFO16;
+		break;
 	case 1:
 	default:
 		fifo_size = PCH_UART_HAL_FIFO_DIS;


