Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0FIXSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:18:14 -0400
Received: from www.tglx.de ([62.245.132.106]:55028 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab0FIXSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:18:12 -0400
Date: Thu, 10 Jun 2010 01:18:08 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Benedikt Spranger <b.spranger@linutronix.de>, Greg KH <gregkh@suse.de>
Subject: [PATCH 3/3] uio: Remove IRQF_DISABLED flag from uio_cif.c
Message-ID: <20100609231807.GE2555@local>
References: <20100609230841.GB2555@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609230841.GB2555@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove IRQF_DISABLED since it is deprecated and a no-op in the
current kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
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
1.7.0

