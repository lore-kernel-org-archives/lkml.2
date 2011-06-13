Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1FMLsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:48:33 -0400
Received: from relay.parallels.com ([195.214.232.42]:39818 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1FMLsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:48:32 -0400
Subject: [PATCH] serial: fix warning in 8250_pci
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Mon, 13 Jun 2011 15:48:25 +0400
Message-ID: <20110613114825.7515.15493.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix trivial "initialization from incompatible pointer type" warning
introduced by v2.6.39-rc4-48-gd9a0fbf

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 drivers/tty/serial/8250_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 4b4968a..78e98a5 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -973,7 +973,7 @@ ce4100_serial_setup(struct serial_private *priv,
 
 static int
 pci_omegapci_setup(struct serial_private *priv,
-		      struct pciserial_board *board,
+		      const struct pciserial_board *board,
 		      struct uart_port *port, int idx)
 {
 	return setup_port(priv, port, 2, idx * 8, 0);

