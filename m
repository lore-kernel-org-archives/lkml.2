Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab1EaPzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:55:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab1EaPxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:53:36 -0400
Date: Tue, 31 May 2011 11:53:35 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155335.3609.13041.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 27/35] drivers/tty changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty changes for SMBIOS and System Firmware

---
 drivers/tty/serial/pch_uart.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index f2cb750..ab2e2af 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -21,7 +21,7 @@
 #include <linux/serial_core.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include <linux/dmaengine.h>
 #include <linux/pch_dma.h>
@@ -1386,6 +1386,16 @@ static struct uart_driver pch_uart_driver = {
 	.nr = PCH_UART_NR,
 };
 
+static const struct sysfw_id pcih_uart_quirk_id[] = {
+	{
+		.ident = "CM-iTC",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "CM-iTC"),
+		},
+	},
+	{}
+};
+
 static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 					     const struct pci_device_id *id)
 {
@@ -1412,7 +1422,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	base_baud = 1843200; /* 1.8432MHz */
 
 	/* quirk for CM-iTC board */
-	if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+	if (sysfw_callback(pcih_uart_quirk_id))
 		base_baud = 192000000; /* 192.0MHz */
 
 	switch (port_type) {
-- 
1.7.5.1

