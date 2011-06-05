Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1FEUv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:51:56 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51898 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1FEUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:51:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH] serial: 8250, increase PASS_LIMIT
Date: Sun,  5 Jun 2011 22:51:49 +0200
Message-Id: <1307307109-27776-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

With virtual machines like qemu, it's pretty common to see "too much
work for irq4" messages nowadays. This happens when a bunch of output
is printed on the emulated serial console. This is caused by too low
PASS_LIMIT. When ISR loops more than the limit, it spits the message.

I've been using a kernel with doubled the limit and I couldn't see no
problems. Maybe it's time to get rid of the message now?

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 54482d7..ae477c8 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -81,7 +81,7 @@ static unsigned int skip_txen_test; /* force skip of txen test at init time */
 #define DEBUG_INTR(fmt...)	do { } while (0)
 #endif
 
-#define PASS_LIMIT	256
+#define PASS_LIMIT	512
 
 #define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
 
-- 
1.7.5.3


