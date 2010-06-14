Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0FNHCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:02:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59250 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0FNHCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:02:03 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ivo Clarysse <ivo.clarysse@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd/mxc_nand: remove unused variable
Date: Mon, 14 Jun 2010 09:01:51 +0200
Message-Id: <1276498911-28115-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes:

	drivers/mtd/nand/mxc_nand.c: In function 'mxcnd_resume':
	drivers/mtd/nand/mxc_nand.c:901: warning: unused variable 'host'

Removing this variable was missed in 9c14b153e6af.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mtd/nand/mxc_nand.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 0d76b16..ef610bf 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -898,7 +898,6 @@ static int mxcnd_resume(struct platform_device *pdev)
 {
 	struct mtd_info *mtd = platform_get_drvdata(pdev);
 	struct nand_chip *nand_chip = mtd->priv;
-	struct mxc_nand_host *host = nand_chip->priv;
 	int ret = 0;
 
 	DEBUG(MTD_DEBUG_LEVEL0, "MXC_ND : NAND resume\n");
-- 
1.7.1

