Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1FWHAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 03:00:25 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:36930 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1FWHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 03:00:23 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH v2] pch_uart: Add MSI support
Date: Thu, 23 Jun 2011 09:00:05 +0200
Message-Id: <1308812405-5245-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4E02857C.1010304@dsn.okisemi.com>
References: <4E02857C.1010304@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
Changes in v2:
* msi_enabled is stored in pci_dev already, skip it in our code

 drivers/tty/serial/pch_uart.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index a3d0c9e..ab34576 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1578,6 +1578,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 		goto init_port_hal_free;
 	}
 
+	pci_enable_msi(pdev);
+
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);
 	priv->mapbase = mapbase;
@@ -1640,6 +1642,8 @@ static void pch_uart_pci_remove(struct pci_dev *pdev)
 	struct eg20t_port *priv;
 
 	priv = (struct eg20t_port *)pci_get_drvdata(pdev);
+
+	pci_disable_msi(pdev);
 #ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
 	pch_uart_ports[priv->port.line] = NULL;
 #endif
@@ -1726,6 +1730,7 @@ static int __devinit pch_uart_pci_probe(struct pci_dev *pdev,
 	return ret;
 
 probe_disable_device:
+	pci_disable_msi(pdev);
 	pci_disable_device(pdev);
 probe_error:
 	return ret;
-- 
1.7.3.4

