Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657Ab0HEWis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:38:48 -0400
Received: from kroah.org ([198.145.64.141]:37694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308Ab0HEWYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/28] uio: Remove IRQF_DISABLED flag from uio_cif.c
Date: Thu,  5 Aug 2010 15:23:53 -0700
Message-Id: <1281047058-23716-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

Remove IRQF_DISABLED since it is deprecated and a no-op in the
current kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio_cif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index 371f87f..a8ea2f1 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -79,7 +79,7 @@ static int __devinit hilscher_pci_probe(struct pci_dev *dev,
 	}
 	info->version = "0.0.1";
 	info->irq = dev->irq;
-	info->irq_flags = IRQF_DISABLED | IRQF_SHARED;
+	info->irq_flags = IRQF_SHARED;
 	info->handler = hilscher_handler;
 
 	if (uio_register_device(&dev->dev, info))
-- 
1.7.2

