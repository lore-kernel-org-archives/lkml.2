Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab0FJPOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:14:23 -0400
Received: from www.tglx.de ([62.245.132.106]:49645 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759106Ab0FJPOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:14:22 -0400
From: John Ogness <john.ogness@linutronix.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: [PATCH 2/3] uio: Remove IRQF_DISABLED from uio_sercos3.c
References: <20100609230841.GB2555@local> <20100609231549.GD2555@local>
Date: Thu, 10 Jun 2010 17:14:10 +0200
In-Reply-To: <20100609231549.GD2555@local> (Hans J. Koch's message of "Thu, 10
	Jun 2010 01:15:49 +0200")
Message-ID: <80ljamdinx.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove IRQF_DISABLED since it is deprecated and a no-op in the
current kernel.

Acked-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
 drivers/uio/uio_sercos3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 3d461cd..a187fa1 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -154,7 +154,7 @@ static int __devinit sercos3_pci_probe(struct pci_dev *dev,
 	info->name = "Sercos_III_PCI";
 	info->version = "0.0.1";
 	info->irq = dev->irq;
-	info->irq_flags = IRQF_DISABLED | IRQF_SHARED;
+	info->irq_flags = IRQF_SHARED;
 	info->handler = sercos3_handler;
 	info->irqcontrol = sercos3_irqcontrol;
 
-- 
1.7.0
