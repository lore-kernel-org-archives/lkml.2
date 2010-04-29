Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299Ab0D3TgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:36:16 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:49223 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934240Ab0D3Tf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:35:59 -0400
X-MXL-Hash: 4bdb311f0e2e3818-b001e2dee7bcff4a8b893378a8056ea2bcb33aa8
X-MXL-Hash: 4bda0dcd34c5a44f-4b773d61d12abd177b9a32f3407651f8241e8fa7
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       "andre@bluewatersys.com" <andre@bluewatersys.com>,
       "ryan@bluewatersys.com" <ryan@bluewatersys.com>
Date: Thu, 29 Apr 2010 17:52:57 -0500
Subject: [PATCH] sst25l.c: remove unnecessary MTD_DEBUG_LEVEL2 messages
Thread-Topic: [PATCH] sst25l.c: remove unnecessary MTD_DEBUG_LEVEL2 messages
Thread-Index: Acrn7rX+O8XanUevTaGL8hiGERGvQw==
Message-ID: <0D753D10438DA54287A00B0270842697636E825604@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010042901)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.31]
X-AnalysisOut: [v=1.0 c=1 a=18M4pvXJG48A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=rggnVFrEAAAA:8 a=utEqgGsK5cjNjDICSCAA:9 a=E8]
X-AnalysisOut: [FvgW13WJUA6VtHz8oA:7 a=F4C1e5et9FwBedBPNqP4oI6CVsMA:4 a=QE]
X-AnalysisOut: [XdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=3Rfx1nUSh_UA:10 a=ct-hs6]
X-AnalysisOut: [iedJYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3UJaqmE009886

All the SST25L series flash parts have uniform erase sectors.  Remove
the extra MTD_DEBUG_LEVEL2 messages showing the eraseregions info
since they could never be shown.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andre Renaud <andre@bluewatersys.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>

---

diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
index fe17054..bcf040b 100644
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -411,17 +411,6 @@ static int __init sst25l_probe(struct spi_device *spi)
 	      flash->mtd.erasesize, flash->mtd.erasesize / 1024,
 	      flash->mtd.numeraseregions);
 
-	if (flash->mtd.numeraseregions)
-		for (i = 0; i < flash->mtd.numeraseregions; i++)
-			DEBUG(MTD_DEBUG_LEVEL2,
-			      "mtd.eraseregions[%d] = { .offset = 0x%llx, "
-			      ".erasesize = 0x%.8x (%uKiB), "
-			      ".numblocks = %d }\n",
-			      i, (long long)flash->mtd.eraseregions[i].offset,
-			      flash->mtd.eraseregions[i].erasesize,
-			      flash->mtd.eraseregions[i].erasesize / 1024,
-			      flash->mtd.eraseregions[i].numblocks);
-
 	if (mtd_has_partitions()) {
 		struct mtd_partition *parts = NULL;
 		int nr_parts = 0;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
