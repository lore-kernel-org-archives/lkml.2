Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1BVVYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:24:42 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56104 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1BVVYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:24:41 -0500
Date: Tue, 22 Feb 2011 13:24:38 -0800
From: Andres Salomon <dilinger@queued.net>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] spi/spi_oc_tiny: fix build error
Message-ID: <20110222132438.02d310e0@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following build error due to a missing semicolon:

 CC [M]  drivers/spi/spi_oc_tiny.o
drivers/spi/spi_oc_tiny.c:394: error: expected ‘,’ or ‘;’ before ‘extern’
make[2]: *** [drivers/spi/spi_oc_tiny.o] Error 1

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/spi/spi_oc_tiny.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_oc_tiny.c b/drivers/spi/spi_oc_tiny.c
index e99e545..f1bde66 100644
--- a/drivers/spi/spi_oc_tiny.c
+++ b/drivers/spi/spi_oc_tiny.c
@@ -390,7 +390,7 @@ static int __devexit tiny_spi_remove(struct platform_device *pdev)
 static const struct of_device_id tiny_spi_match[] = {
 	{ .compatible = "opencores,tiny-spi-rtlsvn2", },
 	{},
-}
+};
 MODULE_DEVICE_TABLE(of, tiny_spi_match);
 #else /* CONFIG_OF */
 #define tiny_spi_match NULL
-- 
1.7.2.3

