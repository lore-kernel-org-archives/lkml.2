Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2IFHTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:19:50 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:22327 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2IFHTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:19:48 -0400
Date: Thu, 6 Sep 2012 09:19:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: [PATCH] dma: ipu: Drop unused spinlock
Message-ID: <20120906091935.64c851ac@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was checking why this spinlock was never initialized, but it turns
out it's not used anywhere, so we can drop it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
---
I can't even build-test this.

 drivers/dma/ipu/ipu_irq.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-3.6-rc4.orig/drivers/dma/ipu/ipu_irq.c	2012-08-04 21:49:26.000000000 +0200
+++ linux-3.6-rc4/drivers/dma/ipu/ipu_irq.c	2012-09-06 09:13:31.034228670 +0200
@@ -45,7 +45,6 @@ static void ipu_write_reg(struct ipu *ip
 struct ipu_irq_bank {
 	unsigned int	control;
 	unsigned int	status;
-	spinlock_t	lock;
 	struct ipu	*ipu;
 };
 


-- 
Jean Delvare
