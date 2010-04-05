Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0DEM4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 08:56:25 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:38493 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab0DEM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 08:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u2+kfYHZtZNJjlMfPZrzd5rdT1wrVk/5/vD8oHwxB7x0bsldC9RDgXrFLppx6+Aiqa
         2GZdDeaAxeF3r6iUbu3RqjF5XDPjNDr13cNnBJ5z/Cj9ws39HcvVUL2KXx6DKQgOSbA+
         2x24yoPTJElmXcg7upx1GGD/DVoowCSq+qats=
MIME-Version: 1.0
In-Reply-To: <003c01cad1b1$da2cdbf0$544ff780@am.dhcp.ti.com>
References: <35697.192.168.10.89.1265898023.squirrel@dbdmail.itg.ti.com>
	 <004701caab40$68b576e0$544ff780@am.dhcp.ti.com>
	 <x2q7f9d1ffb1003302307nb8e91be0o55da59c3375f1720@mail.gmail.com>
	 <v2yce9ab5791003302327hc67deb3akc7d18146534038f9@mail.gmail.com>
	 <h2p7f9d1ffb1003310003z508e21dbqe37b6e1cad425866@mail.gmail.com>
	 <003b01cad0f0$6ea78040$544ff780@am.dhcp.ti.com>
	 <g2s7f9d1ffb1003312331o149df218g651c3e4349ac9a77@mail.gmail.com>
	 <003c01cad1b1$da2cdbf0$544ff780@am.dhcp.ti.com>
Date: Mon, 5 Apr 2010 18:26:16 +0530
Message-ID: <m2n7f9d1ffb1004050556o1ed2eec8ief66d60fc85f96de@mail.gmail.com>
Subject: [PATCH v3] OMAP: Fix for bus width which improves SD card's 
	peformance.
From: kishore kadiyala <kishorek.kadiyala@gmail.com>
To: Madhusudhan <madhu.cr@ti.com>
Cc: Vimal Singh <vimal.newwork@gmail.com>, tony@atomide.com, svenkatr@ti.com,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       jarkko.lavinen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishore Kadiyala <kishore.kadiyala@ti.com>

This patch improves low speeds for SD cards.
OMAP-MMC controller's can support maximum bus width of '8'.
when bus width is mentioned as "8" in controller data,the SD
stack will check whether bus width is "4" and if not it will
set bus width to "1" and there by degrading performance.
This patch fixes the issue and improves the performance of
SD cards.

Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Tested-by: Jarkko Nikula <jhnikula@gmail.com>
---
In V3 : Updated  with Madhu's comments  and appended Tested by Nikula
In V2 : Appended Signed-off by Venkat and Ack by Madhu

 Here are my experiment numbers, on a Class 6 SDHC card:
 Read peformance is increased by 220%
 Write Performance is increased by 52%

 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
 drivers/mmc/host/omap_hsmmc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 83f0aff..44e79f7 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2091,9 +2091,9 @@ static int __init omap_hsmmc_probe(struct
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
 		     MMC_CAP_WAIT_WHILE_BUSY;

-	if (mmc_slot(host).wires >= 8)
-		mmc->caps |= MMC_CAP_8_BIT_DATA;
-	else if (mmc_slot(host).wires >= 4)
+	if (mmc_slot(host).wires == 8)
+		mmc->caps |= (MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA);
+	else if (mmc_slot(host).wires == 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;

 	if (mmc_slot(host).nonremovable)
-- 
1.6.3.3
