Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0DBWqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 18:46:47 -0400
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:49265 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab0DBWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 18:46:41 -0400
X-MXL-Hash: 4bb673d1022d59af-53ddfacbb26e30d64b7f62ed169eb4c5ce54ef6d
X-MXL-Hash: 4bb673ce2c89a5d4-d5fcbe37b48b398fa16a690914d4ef69d21e5d40
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>
Date: Fri, 2 Apr 2010 17:46:30 -0500
Subject: [PATCH] mtd/maps/physmap: catch failure to register
 MTD_PHYSMAP_COMPAT device
Thread-Topic: [PATCH] mtd/maps/physmap: catch failure to register
 MTD_PHYSMAP_COMPAT device
Thread-Index: AcrStlYuoomRNasvSPyEISJe3+ZIrQ==
Message-ID: <0D753D10438DA54287A00B0270842697636A7E9D36@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040101)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.32]
X-AnalysisOut: [v=1.0 c=1 a=oeBtjfINvzoA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=PiArxPsHRB7F9zrSCacA:9 a=L6]
X-AnalysisOut: [1zGsoZGOwhTTX9q0zvaYh45ZsA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAw]
X-AnalysisOut: [usA:10 a=3Rfx1nUSh_UA:10 a=7DSvI1NPTFQA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o32MkpmE001102

If the default Kconfig values are used with MTD_PHYSMAP_COMPAT you end
up with a resource where end < start.  This causes __request_resource to
return a conflict which then returns an -EBUSY error code.  The current
physmap.c code just assumes that the platfom_device_register will always
succeed.

Catch this failure during the physmap_init and propogate the error.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>

---

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index d9603f7..426461a 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -264,8 +264,11 @@ static int __init physmap_init(void)
 
 	err = platform_driver_register(&physmap_flash_driver);
 #ifdef CONFIG_MTD_PHYSMAP_COMPAT
-	if (err == 0)
-		platform_device_register(&physmap_flash);
+	if (err == 0) {
+		err = platform_device_register(&physmap_flash);
+		if (err)
+			platform_driver_unregister(&physmap_flash_driver);
+	}
 #endif
 
 	return err;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
