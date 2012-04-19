Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099Ab2DSV1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:27:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab2DSVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:16:13 -0400
Message-Id: <20120419210820.901366605@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:08:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 26/68] pch_uart: Fix MSI setting issue
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 867c902e07d5677e2a5b54c0435e589513abde48 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/pch_uart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1438,6 +1438,7 @@ static struct eg20t_port *pch_uart_init_
 	}
 
 	pci_enable_msi(pdev);
+	pci_set_master(pdev);
 
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);


