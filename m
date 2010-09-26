Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0IZLbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 07:31:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55781 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab0IZLbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 07:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=m6beM3PZXmh5QoRn3i2mcI7VKJS/6F1CazdSCRnCi/TMqv0fTd5V6AA8WzfEOy0FsQ
         PuFmgqOj/2bdYu95cgrnYHo8/YKNCDuOfi1UtaSpQ24Yh562KGlzJgE4RTTLCoyhrFk/
         9Rd/TD73cXe7T3d9WDt2tzSDgpPX0TkvRfGOE=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: linux@dominikbrodowski.net, komurojun-mbn@nifty.com, w.sang@pengutronix.de,
        davem@davemloft.net
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] pcmcia: pd6729: Fix error path
Date: Sun, 26 Sep 2010 17:00:29 +0530
Message-Id: <1285500629-6024-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In error return path
call pci_disable_device() which was enabled earlier.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/pcmcia/pd6729.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index b8a869a..deef665 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -646,7 +646,7 @@ static int __devinit pd6729_pci_probe(struct pci_dev *dev,
 	if (!pci_resource_start(dev, 0)) {
 		dev_warn(&dev->dev, "refusing to load the driver as the "
 			"io_base is NULL.\n");
-		goto err_out_free_mem;
+		goto err_out_disable;
 	}
 
 	dev_info(&dev->dev, "Cirrus PD6729 PCI to PCMCIA Bridge at 0x%llx "
-- 
1.7.2.3

