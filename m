Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1E3JxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:53:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53356 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab1E3Jw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:52:59 -0400
From: Borislav Petkov <bp@alien8.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Antony Pavlov <antony@niisi.msk.ru>
Subject: [PATCH] 8250_pci: Fix build warning
Date: Mon, 30 May 2011 11:52:54 +0200
Message-Id: <1306749174-31216-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.rc1.16.g9db1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix

drivers/tty/serial/8250_pci.c:1457: warning: initialization from incompatible pointer type

by constifying the serial board :).

Cc: Antony Pavlov <antony@niisi.msk.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/tty/serial/8250_pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 4b4968a..c9c9e6f 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -973,8 +973,8 @@ ce4100_serial_setup(struct serial_private *priv,
 
 static int
 pci_omegapci_setup(struct serial_private *priv,
-		      struct pciserial_board *board,
-		      struct uart_port *port, int idx)
+		   const struct pciserial_board *board,
+		   struct uart_port *port, int idx)
 {
 	return setup_port(priv, port, 2, idx * 8, 0);
 }
-- 
1.7.5.rc1.16.g9db1

