Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0CaHDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:03:06 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:44941 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0CaHDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=whNnou/ZS7jGuAk6FmQIrmxUnKfxjO4AT3/YvjAbzKEimqlwu75UADaU1kHQxk0FXq
         H4c3hwUzbpy0P50s+iSl2S6sghFlwIjxTYHtxFKYbFupZ6Z0F5TKZs+SV5ceid52FjQg
         Ups97tRwTlPDLdtdFEnRSAG8grm41iXE9dXw0=
MIME-Version: 1.0
In-Reply-To: <v2yce9ab5791003302327hc67deb3akc7d18146534038f9@mail.gmail.com>
References: <35697.192.168.10.89.1265898023.squirrel@dbdmail.itg.ti.com>
	 <004701caab40$68b576e0$544ff780@am.dhcp.ti.com>
	 <x2q7f9d1ffb1003302307nb8e91be0o55da59c3375f1720@mail.gmail.com>
	 <v2yce9ab5791003302327hc67deb3akc7d18146534038f9@mail.gmail.com>
Date: Wed, 31 Mar 2010 12:33:01 +0530
Message-ID: <h2p7f9d1ffb1003310003z508e21dbqe37b6e1cad425866@mail.gmail.com>
Subject: Re: [PATCH-V2] OMAP: Fix for bus width which improves SD card's 
	peformance.
From: kishore kadiyala <kishorek.kadiyala@gmail.com>
To: Vimal Singh <vimal.newwork@gmail.com>
Cc: Madhusudhan <madhu.cr@ti.com>, tony@atomide.com, svenkatr@ti.com,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       jarkko.lavinen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for that and here's the Updated one.

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

---
In V2 : Appended Signed-off by Venkat and Ack by Madhu

 Here are my experiment numbers, on a Class 6 SDHC card:
 Read peformance is increased by 220%
 Write Performance is increased by 52%

 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 83f0aff..8c97c22 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2092,7 +2092,7 @@ static int __init omap_hsmmc_probe(struct
 		     MMC_CAP_WAIT_WHILE_BUSY;

 	if (mmc_slot(host).wires >= 8)
-		mmc->caps |= MMC_CAP_8_BIT_DATA;
+		mmc->caps |= (MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA);
 	else if (mmc_slot(host).wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;

-- 
1.6.3.3
