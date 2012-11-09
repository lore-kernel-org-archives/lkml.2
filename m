Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2KIGGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 01:06:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:37520 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2KIGGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 01:06:41 -0500
Date: Fri, 9 Nov 2012 07:06:40 +0100
From: Manuel Traut <manut@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Staedtler <stefan.staedtler@siemens.com>
Subject: [PATCH] uio_pdrv: set memory mapping name
Message-ID: <20121109060640.GW15531@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If uio_pdrv[_genirq] is used, the uio maps have currently no name set.
This patch sets the uio_mem name to the name of the memory resource.
 
Signed-off-by: Manuel Traut <manut@linutronix.de>
Reported-by: Stefan Staedtler <stefan.staedtler@siemens.com>
Tested-by: Stefan Staedtler <stefan.staedtler@siemens.com>

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 42202cd..ac988ce 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -172,6 +172,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 		uiomem->memtype = UIO_MEM_PHYS;
 		uiomem->addr = r->start;
 		uiomem->size = resource_size(r);
+		uiomem->name = r->name;
 		++uiomem;
 	}
 
diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
index 72d3646..39be9e0 100644
--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -60,6 +60,7 @@ static int uio_pdrv_probe(struct platform_device *pdev)
 		uiomem->memtype = UIO_MEM_PHYS;
 		uiomem->addr = r->start;
 		uiomem->size = resource_size(r);
+		uiomem->name = r->name;
 		++uiomem;
 	}
 
