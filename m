Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1BVVXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:23:08 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56098 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1BVVXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:23:07 -0500
Date: Tue, 22 Feb 2011 13:23:03 -0800
From: Andres Salomon <dilinger@queued.net>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] spi/spi_altera: fix build error
Message-ID: <20110222132303.6a78b8e0@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into a build error while attempting to build the Feb 22nd
linux-next tree.



From: Andres Salomon <dilinger@queued.net>

Fix the following build error due to a missing semicolon:

 CC [M]  drivers/spi/spi_altera.o
drivers/spi/spi_altera.c:308: error: expected ‘,’ or ‘;’ before ‘extern’
make[2]: *** [drivers/spi/spi_altera.o] Error 1

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/spi/spi_altera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_altera.c b/drivers/spi/spi_altera.c
index 5e001f3..4813a63 100644
--- a/drivers/spi/spi_altera.c
+++ b/drivers/spi/spi_altera.c
@@ -304,7 +304,7 @@ static int __devexit altera_spi_remove(struct platform_device *dev)
 static const struct of_device_id altera_spi_match[] = {
 	{ .compatible = "ALTR,spi-1.0", },
 	{},
-}
+};
 MODULE_DEVICE_TABLE(of, altera_spi_match);
 #else /* CONFIG_OF */
 #define altera_spi_match NULL
-- 
1.7.2.3

