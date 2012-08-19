Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2HSIsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:48:21 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:52549 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040Ab2HSIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:44:48 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="170216900"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: kernel-janitors@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] drivers/spi/spi-coldfire-qspi.c: fix error return code
Date: Sun, 19 Aug 2012 10:44:25 +0200
Message-Id: <1345365870-29831-10-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize return variable before exiting on an error path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/spi/spi-coldfire-qspi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index b2d4b9e..7889796 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -462,6 +462,7 @@ static int __devinit mcfqspi_probe(struct platform_device *pdev)
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
 		dev_dbg(&pdev->dev, "platform data is missing\n");
+		status = -EINVAL;
 		goto fail4;
 	}
 	master->bus_num = pdata->bus_num;

