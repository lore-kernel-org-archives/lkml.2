Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1IWGQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:16:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51000 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1IWGQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:16:09 -0400
Date: Fri, 23 Sep 2011 09:16:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] dma/timberdale: free_irq() on an error path
Message-ID: <20110923061601.GB4387@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E7C2427.007C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was an error path that skipped the free_irq() step by mistake.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 6dbdf45..a4a398f 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -762,7 +762,7 @@ static int __devinit td_probe(struct platform_device *pdev)
 		if ((i % 2) == pchan->rx) {
 			dev_err(&pdev->dev, "Wrong channel configuration\n");
 			err = -EINVAL;
-			goto err_tasklet_kill;
+			goto err_free_irq;
 		}
 
 		td_chan->chan.device = &td->dma;
