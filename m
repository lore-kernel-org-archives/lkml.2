Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0HITvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:51:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61728 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab0HITvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dWbnrvI5M4jZsPDZHbKF7LUnh/qKIKGSXyVtj509o/3RqRD90GXzcH+Z926bYFjOc1
         YEJ/XE3/1MBHPqXsxLDyevpM0U+4odtUApdS68+ewltBM+8Uc2pfFZ8p3ClXFWDMdLPw
         mwia7g9DM+FPXMEi4ZytllMibsmDWu9kFM/lw=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Komuro <komurojun-mbn@nifty.com>, Wolfram Sang <w.sang@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/18 v2] pcmcia: pd6729: call disable_pci_device() if pci_probe() failed
Date: Mon,  9 Aug 2010 23:51:38 +0400
Message-Id: <1281383500-14398-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.  Also it must not be called if pci_request_region() fails as
it means that somebody uses device resources and rules the device.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
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
1.7.0.4

