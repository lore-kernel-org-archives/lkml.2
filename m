Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab0GOSZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:25:11 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:30119 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933977Ab0GOSZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:25:09 -0400
Date: Thu, 15 Jul 2010 22:25:07 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: [PATCH v2] edac: mpc85xx: Add support for new MPCxxx/Pxxxx EDAC
 controllers
Message-ID: <20100715182507.GA3482@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply add proper IDs into the device table.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---

It appears that the driver has two device ID tables. :-)
So, my previous attempt enabled only half of the functionality.

Andrew,

Can you please replace

  edac-mpc85xx-add-support-for-mpc8569-edac-controllers.patch

with this patch? It also adds some more IDs for the newer chips.

Thanks!

 drivers/edac/mpc85xx_edac.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 52ca09b..3820879 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -646,8 +646,12 @@ static struct of_device_id mpc85xx_l2_err_of_match[] = {
 	{ .compatible = "fsl,mpc8555-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8569-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
+	{ .compatible = "fsl,p1020-l2-cache-controller", },
+	{ .compatible = "fsl,p1021-l2-cache-controller", },
 	{ .compatible = "fsl,p2020-l2-cache-controller", },
+	{ .compatible = "fsl,p4080-l2-cache-controller", },
 	{},
 };
 
@@ -1120,9 +1124,13 @@ static struct of_device_id mpc85xx_mc_err_of_match[] = {
 	{ .compatible = "fsl,mpc8555-memory-controller", },
 	{ .compatible = "fsl,mpc8560-memory-controller", },
 	{ .compatible = "fsl,mpc8568-memory-controller", },
+	{ .compatible = "fsl,mpc8569-memory-controller", },
 	{ .compatible = "fsl,mpc8572-memory-controller", },
 	{ .compatible = "fsl,mpc8349-memory-controller", },
+	{ .compatible = "fsl,p1020-memory-controller", },
+	{ .compatible = "fsl,p1021-memory-controller", },
 	{ .compatible = "fsl,p2020-memory-controller", },
+	{ .compatible = "fsl,p4080-memory-controller", },
 	{},
 };
 
-- 
1.7.0.5
