Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab1FILV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:21:28 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:41170 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab1FILVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:21:22 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH v2] pch_uart: Don't oops if dmi_get_system_info returns NULL
Date: Thu,  9 Jun 2011 13:21:15 +0200
Message-Id: <1307618475-7273-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110608144419.e5b3034c.akpm@linux-foundation.org>
References: <20110608144419.e5b3034c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This oops was observed on an Atom based board which has no BIOS, but
a bootloder which doesn't privde DMI data.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
Changesin v2:
* Adjust summary
* Describe when dmi_get_system_info could return NULL

If this is ok, i will send an updated patch for the pch_phub too.

 drivers/tty/serial/pch_uart.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index f2cb750..4652109 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1397,6 +1397,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	int fifosize, base_baud;
 	int port_type;
 	struct pch_uart_driver_data *board;
+	const char *board_name;
 
 	board = &drv_dat[id->driver_data];
 	port_type = board->port_type;
@@ -1412,7 +1413,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	base_baud = 1843200; /* 1.8432MHz */
 
 	/* quirk for CM-iTC board */
-	if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+	board_name = dmi_get_system_info(DMI_BOARD_NAME);
+	if (board_name && strstr(board_name, "CM-iTC"))
 		base_baud = 192000000; /* 192.0MHz */
 
 	switch (port_type) {
-- 
1.7.3.4

