Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab2DBFg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:36:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46795 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2DBFgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:36:55 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] pch_uart: Fix MSI setting issue
Date: Mon,  2 Apr 2012 14:36:22 +0900
Message-Id: <1333344982-5130-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch (MSI setting) is not enough.


commit e463595fd9c752fa4bf06b47df93ef9ade3c7cf0
Author: Alexander Stein <alexander.stein@systec-electronic.com>
Date:   Mon Jul 4 08:58:31 2011 +0200

    pch_uart: Add MSI support
    
    Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

To enable MSI mode, PCI bus-mastering must be enabled.
This patch enables the setting.

cc: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 5928877..ae8f848 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1586,6 +1586,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	}
 
 	pci_enable_msi(pdev);
+	pci_set_master(pdev);
 
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);
-- 
1.7.7.6

