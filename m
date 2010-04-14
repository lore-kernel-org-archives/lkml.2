Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0DNX3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:29:37 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:47188 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab0DNX3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:29:35 -0400
X-MXL-Hash: 4bc64fdf043652e2-9d4fa85787b0d3947b1c3df5b96440ba2fa30018
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Greg KH <greg@kroah.com>, "ss@aao.gov.au" <ss@aao.gov.au>
Date: Wed, 14 Apr 2010 18:29:17 -0500
Subject: [PATCH] staging/dt3155: fix 50Hz configuration
Thread-Topic: [PATCH] staging/dt3155: fix 50Hz configuration
Thread-Index: AcrcKk08qQbuFR/sRs+p5KTQeaFlZg==
Message-ID: <0D753D10438DA54287A00B0270842697636D62B002@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=13beN-c2da8A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=i00gxMtYAAAA:8 a=JhO]
X-AnalysisOut: [pUDsbAAAA:8 a=oWM6WVPIm1j3StMXHvUA:9 a=CW_TKV6tCWPASGpxDak]
X-AnalysisOut: [vmYeY7UkA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=0kPLrQdw]
X-AnalysisOut: [3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3ENTnmE021007

According to the header file, dt3155_io.h, the 50/60 Hz configuration
is controlled by a bit in the I2C CSR2 register (bit 2).  The function
dt3155_init_isr actually reads the I2C CONFIG register into the global
I2C_CSR union variable then modifies the bit.  It then does a write
to the I2C CONFIG register with the global I2C_CONFIG union variable
which is not even set with a value anywhere in the driver.

My guess is 50Hz operation doesn't even work as-is.

Fix this by actually reading and writing the correct register with
the correct value.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Simon Horman <horms@verge.net.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index a67c622..8c43284 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -472,9 +472,9 @@ static void dt3155_init_isr(int minor)
   /* 50/60 Hz should be set before this point but let's make sure it is */
   /* right anyway */
 
-  ReadI2C(dt3155_lbase[ minor ], CONFIG, &i2c_csr2.reg);
+  ReadI2C(dt3155_lbase[ minor ], CSR2, &i2c_csr2.reg);
   i2c_csr2.fld.HZ50 = FORMAT50HZ;
-  WriteI2C(dt3155_lbase[ minor ], CONFIG, i2c_config.reg);
+  WriteI2C(dt3155_lbase[ minor ], CSR2, i2c_csr2.reg);
 
   /* enable busmaster chip, clear flags */
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
