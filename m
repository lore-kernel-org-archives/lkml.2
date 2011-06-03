Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1FCBM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:12:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61540 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1FCBM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pjwqwweO2SAPLDXeBL9YOVbW0sguXE8tC8vvlX+TpmJNtnQk9lrWA689kpHP3i7VX5
         D3fEOYP2ONEnX9zGjLNwsSFd2jlHPPyQ2NcMNoSV5tD6s+M8jHAw1AGMQaUKsnvV23jp
         7oH95INgjyAFZllZ5XmkXyWf2C0vTx1A0/daI=
Subject: [PATCH] mtd: denali: remove calling mtd_device_unregister() after
 nand_release()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        Jamie Iles <jamie@jamieiles.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 09:12:15 +0800
Message-ID: <1307063535.10001.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of nand_release() already call mtd_device_unregister(),
no need to call it again.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/denali.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index d527621..e119748 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1676,7 +1676,6 @@ static void denali_pci_remove(struct pci_dev *dev)
 	struct denali_nand_info *denali = pci_get_drvdata(dev);
 
 	nand_release(&denali->mtd);
-	mtd_device_unregister(&denali->mtd);
 
 	denali_irq_cleanup(dev->irq, denali);
 
-- 
1.7.4.1



