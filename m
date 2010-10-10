Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab0JJR2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:28:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0JJR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KN/CFmINmCjRkOB5UoWw4RTm/yk1w0w37YzgtQq+HUzCHidxDYso3AiC0Pyogts4ee
         b3/Om3VibM4cPaWGRP7nvROUCIh797OvYMD/snfh76pSxqDcPe+WOkKAkXf0tLkN6fEm
         TYVa7LPltCmmH49mkOWl00O4Qk1iHpMCAEmWQ=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "Govindraj.R" <govindraj.raja@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: omap-serial: fix signess error
Date: Sun, 10 Oct 2010 21:28:35 +0400
Message-Id: <1286731715-17908-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ret" is unsigned, so check for (ret < 0) made no sense.
Made it signed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested.

 drivers/serial/omap-serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
index 2ee1d32..14365f7 100644
--- a/drivers/serial/omap-serial.c
+++ b/drivers/serial/omap-serial.c
@@ -1055,7 +1055,7 @@ static void serial_omap_rx_timeout(unsigned long uart_no)
 {
 	struct uart_omap_port *up = ui[uart_no];
 	unsigned int curr_dma_pos, curr_transmitted_size;
-	unsigned int ret = 0;
+	int ret = 0;
 
 	curr_dma_pos = omap_get_dma_dst_pos(up->uart_dma.rx_dma_channel);
 	if ((curr_dma_pos == up->uart_dma.prev_rx_dma_pos) ||
-- 
1.7.0.4

