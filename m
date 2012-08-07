Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2HGDip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:38:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59721 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757341Ab2HGDib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:31 -0400
Message-Id: <20120807032805.943189866@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:29:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        <dcb314@hotmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 68/70] pch_uart: Fix missing break for 16 byte fifo
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 9bc03743fff0770dc5a5324ba92e67cc377f16ca upstream.

Otherwise we fall back to the wrong value.

Reported-by: <dcb314@hotmail.com>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44091
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/pch_uart.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index d291518..c5bc23d 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1266,6 +1266,7 @@ static int pch_uart_startup(struct uart_port *port)
 		break;
 	case 16:
 		fifo_size = PCH_UART_HAL_FIFO16;
+		break;
 	case 1:
 	default:
 		fifo_size = PCH_UART_HAL_FIFO_DIS;


