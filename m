Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1J0Gpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 02:45:47 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33645 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab1J0Gpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 02:45:45 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 1/2] pch_uart: Fix hw-flow control issue
Date: Thu, 27 Oct 2011 15:45:18 +0900
Message-Id: <1319697919-5623-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using hardware flow control,
currently, register of the control-bit(AFE) is not set.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/tty/serial/pch_uart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index b950d05..b1aabe8 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1290,6 +1290,7 @@ static void pch_uart_set_termios(struct uart_port *port,
 	if (rtn)
 		goto out;
 
+	pch_uart_set_mctrl(&priv->port, priv->port.mctrl);
 	/* Don't rewrite B0 */
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
-- 
1.7.4.4

