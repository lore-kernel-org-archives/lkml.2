Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab2IYVi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:38:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31201 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab2IYVim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:38:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/pciback: When resetting the device don't disable twice.
Date: Tue, 25 Sep 2012 17:27:20 -0400
Message-Id: <1348608440-4018-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348608440-4018-1-git-send-email-konrad.wilk@oracle.com>
References: <1348608440-4018-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call 'pci_disable_device' which sets the bus_master to zero
and it also disables the PCI_COMMAND. There is no need to
do it outside the PCI library.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pciback_ops.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
index 97f5d26..2e62279 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -114,10 +114,6 @@ void xen_pcibk_reset_device(struct pci_dev *dev)
 			pci_disable_msi(dev);
 #endif
 		pci_disable_device(dev);
-
-		pci_write_config_word(dev, PCI_COMMAND, 0);
-
-		dev->is_busmaster = 0;
 	} else {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
 		if (cmd & (PCI_COMMAND_INVALIDATE)) {
-- 
1.7.7.6

