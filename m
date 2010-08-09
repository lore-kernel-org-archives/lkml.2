Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0HITto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:49:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55443 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab0HITtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AXV8KIcngxV940tf6A0GhCKaBbN3DtpohyQTpeR7vI/KWQ8ERTz54pZ3QRYv6I1XLl
         qFm3lSlpLqKpROpgc5GFRZnz1PydYwLVAL1Xf49YJ7DJeLNC9CeCuE94Yxx52eJzBRTL
         vlKJE0kHvZUTdbKwJRUI10mOI4GxlkyxbNt7Q=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/18 v2] char: sx: call disable_pci_device() if pci_probe() failed
Date: Mon,  9 Aug 2010 23:49:35 +0400
Message-Id: <1281383377-13657-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/sx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 5b24db4..759563e 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2678,7 +2678,7 @@ static int __devinit sx_pci_probe(struct pci_dev *pdev,
 	retval = pci_request_region(pdev, reg, "sx");
 	if (retval) {
 		dev_err(&pdev->dev, "can't request region\n");
-		goto err_flag;
+		goto err_disable;
 	}
 	board->hw_base = pci_resource_start(pdev, reg);
 	board->base2 =
@@ -2711,6 +2711,8 @@ err_unmap:
 	iounmap(board->base2);
 err_reg:
 	pci_release_region(pdev, reg);
+err_disable:
+	pci_disable_device(pdev);
 err_flag:
 	board->flags &= ~SX_BOARD_PRESENT;
 err:
-- 
1.7.0.4

