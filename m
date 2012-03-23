Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2CWOX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:23:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36932 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab2CWOXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:23:54 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?q?S=C3=B8ren=20holm?= <sgh@sgh.dk>,
        Johan Hovold <jhovold@gmail.com>, stable <stable@vger.kernel.org>
Subject: [PATCH] USB: pl2303: fix DTR/RTS being raised on baud rate change
Date: Fri, 23 Mar 2012 15:23:18 +0100
Message-Id: <1332512598-5720-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <20120323142249.GB11407@localhost>
References: <20120323142249.GB11407@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DTR/RTS should only be raised when changing baudrate from B0 and not on
any baud rate change (> B0).

Reported-by: Søren Holm <sgh@sgh.dk>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/pl2303.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 052c401..c3b1911 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -420,7 +420,7 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	control = priv->line_control;
 	if ((cflag & CBAUD) == B0)
 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	else
+	else if ((old_termios->c_cflag & CBAUD) == B0)
 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
 	if (control != priv->line_control) {
 		control = priv->line_control;
-- 
1.7.8.5

