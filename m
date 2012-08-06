Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2HFScF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:32:05 -0400
Received: from www17.your-server.de ([213.133.104.17]:47766 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2HFSb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:31:58 -0400
Subject: [PATCH] spi: Use PTR_RET rather than if(IS_ERR(.. [1]
From: Thomas Meyer <thomas@m3y3r.de>
To: "[grant.likely@secretlab.ca, rob.herring@calxeda.com, spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org]"@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Mon, 06 Aug 2012 19:51:17 +0200
Message-ID: <1344275477.14513.113.camel@localhost.localdomain>
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/ptr_ret.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -1134,9 +1134,7 @@ static int __devinit plat_mpc8xxx_spi_pr
 		return -EINVAL;
 
 	master = fsl_spi_probe(&pdev->dev, mem, irq);
-	if (IS_ERR(master))
-		return PTR_ERR(master);
-	return 0;
+	return PTR_RET(master);
 }
 
 static int __devexit plat_mpc8xxx_spi_remove(struct platform_device *pdev)
