Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2EFPFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 11:05:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51006 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2EFPFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 11:05:35 -0400
MIME-Version: 1.0
From: girish verma <girish.gcet@gmail.com>
Date: Sun, 6 May 2012 20:35:13 +0530
Message-ID: <CAMC5Lb4bMfqnWuvzcisGNV-uM08vHJMLt8X+mYmOp0P6RzqtrA@mail.gmail.com>
Subject: [patch] xhci: testing sizeof xhci_doorbell_array 2 time
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing BUILD_BUG_ON xhci_doorbell_array structure 2 time, redundant statement

Signed-off-by: Girish Verma <girish.gcet@gmail.com>

 ---
 drivers/usb/host/xhci.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 36641a7..cfcf733 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4090,7 +4090,6 @@ static int __init xhci_hcd_init(void)
 	BUILD_BUG_ON(sizeof(struct xhci_intr_reg) != 8*32/8);
 	/* xhci_run_regs has eight fields and embeds 128 xhci_intr_regs */
 	BUILD_BUG_ON(sizeof(struct xhci_run_regs) != (8+8*128)*32/8);
-	BUILD_BUG_ON(sizeof(struct xhci_doorbell_array) != 256*32/8);
 	return 0;
 unreg_pci:
 	xhci_unregister_pci();
--
