Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2HVLmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:42:53 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:45380 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357Ab2HVLmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:42:50 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336341600"; 
   d="scan'208";a="170506400"
Date: Wed, 22 Aug 2012 13:42:47 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Kukjin Kim <kgene.kim@samsung.com>,
        "'Julia Lawall'" <Julia.Lawall@lip6.fr>,
        "'Ben Dooks'" <ben-linux@fluff.org>, kernel-janitors@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] drivers/spi/spi-s3c24xx.c: fix error return code
In-Reply-To: <20120822114015.GI7995@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.02.1208221342240.1991@hadrien>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr> <1345365870-29831-15-git-send-email-Julia.Lawall@lip6.fr> <1b3201cd8049$e753f720$b5fbe560$%kim@samsung.com> <20120822114015.GI7995@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
Perhaps -EINVAL is not the right value in this case.

 drivers/spi/spi-s3c24xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-s3c24xx.c b/drivers/spi/spi-s3c24xx.c
index 8ee7d79..a2a080b 100644
--- a/drivers/spi/spi-s3c24xx.c
+++ b/drivers/spi/spi-s3c24xx.c
@@ -611,6 +611,7 @@ static int __devinit s3c24xx_spi_probe(struct platform_device *pdev)
 	if (!pdata->set_cs) {
 		if (pdata->pin_cs < 0) {
 			dev_err(&pdev->dev, "No chipselect pin\n");
+			err = -EINVAL;
 			goto err_register;
 		}


