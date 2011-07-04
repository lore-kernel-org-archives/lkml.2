Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1GDHHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:07:52 -0400
Received: from 61-96-236-77.server-home.net ([77.236.96.61]:35969 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab1GDHHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:07:50 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jul 2011 03:07:50 EDT
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Greg KH <greg@kroah.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH v3] pch_uart: Add MSI support
Date: Mon,  4 Jul 2011 08:58:31 +0200
Message-Id: <1309762711-8571-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110701223209.GA9581@kroah.com>
References: <20110701223209.GA9581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
Hello Greg,

I'm sorry. This patch was based some other patches, like console support.

Changes in v3:
* Rebased to current git master

 drivers/tty/serial/pch_uart.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4652109..d3ba85b 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1429,6 +1429,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 		goto init_port_hal_free;
 	}
 
+	pci_enable_msi(pdev);
+
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);
 	priv->mapbase = mapbase;
@@ -1485,6 +1487,8 @@ static void pch_uart_pci_remove(struct pci_dev *pdev)
 	struct eg20t_port *priv;
 
 	priv = (struct eg20t_port *)pci_get_drvdata(pdev);
+
+	pci_disable_msi(pdev);
 	pch_uart_exit_port(priv);
 	pci_disable_device(pdev);
 	kfree(priv);
@@ -1568,6 +1572,7 @@ static int __devinit pch_uart_pci_probe(struct pci_dev *pdev,
 	return ret;
 
 probe_disable_device:
+	pci_disable_msi(pdev);
 	pci_disable_device(pdev);
 probe_error:
 	return ret;
-- 
1.7.3.4

