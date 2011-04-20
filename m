Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1DTInb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:43:31 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51019 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1DTIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:43:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/7] Char: nozomi, use GFP_KERNEL for kfifo allocation
Date: Wed, 20 Apr 2011 10:43:12 +0200
Message-Id: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocation was moved to probe function in 9842c38e9176. And we can
sleep there. So allocate the 4*8192 bytes as GFP_KERNEL to mitigate
the allocation failure.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Tested-by: Gerald Pfeifer <gerald@pfeifer.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/nozomi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index fd0a9852..acaecc1 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1431,8 +1431,8 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	}
 
 	for (i = PORT_MDM; i < MAX_PORT; i++) {
-		if (kfifo_alloc(&dc->port[i].fifo_ul,
-		      FIFO_BUFFER_SIZE_UL, GFP_ATOMIC)) {
+		if (kfifo_alloc(&dc->port[i].fifo_ul, FIFO_BUFFER_SIZE_UL,
+					GFP_KERNEL)) {
 			dev_err(&pdev->dev,
 					"Could not allocate kfifo buffer\n");
 			ret = -ENOMEM;
-- 
1.7.4.2


