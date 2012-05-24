Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2EXGJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:09:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14337 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2EXGJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:09:00 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-61-4fbdd07b40db
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] mfd: Fix build break of max77693 by adding REGMAP_I2C option
Date: Thu, 24 May 2012 15:08:58 +0900
Message-id: <1337839738-18246-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t9jQd3qC3v9Df5u47e4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZe1//YS84xF/xt+UecwPjXt4uRnYOCQETiZ3sXYycQJaYxIV7
	69lAbCGB6YwS53cUdTFyAdnLmCT6nj1nBkmwCWhJ7H9xA6xIREBS4tnjdYwgNrNArcS+a02s
	ILawgK/EyX+PwWpYBFQlvn3vAavhFXCVaPm+iglimYJE67JD7BMYuRcwMqxiFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECPbeM6kdjCsbLA4xCnAwKvHwfjy311+INbGsuDL3EKMEB7OSCK9X
	MVCINyWxsiq1KD++qDQntfgQozQHi5I4r93iHf5CAumJJanZqakFqUUwWSYOTqkGxsS8v+tr
	Sjg0Ag0O3je8OtVp2V1epZveov+t5+7a5so4L97Gwvjst0TFuPXGX28wSfF1vOg4ePseQ91v
	zfrE05uEm7lEtmUFNm3uuBdh3PUs++/fqgtn0ifd+/FEW967tbI1Zf0NjbJ9bPOS3Vz/eXiw
	WCU3nGc4eeVxc8H5jxYXrlR915GWVmIpzkg01GIuKk4EAHSD8V3aAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add REGMAP_I2C config option to fix build break
of max77693 mfd driver because max77693 use regmap interface
for i2c communication.

drivers/mfd/max77693.c:103: error: variable 'max77693_regmap_config' has initializer but incomplete type
drivers/mfd/max77693.c:104: error: unknown field 'reg_bits' specified in initializer
drivers/mfd/max77693.c:104: warning: excess elements in struct initializer
drivers/mfd/max77693.c:104: warning: (near initialization for 'max77693_regmap_config')
drivers/mfd/max77693.c:105: error: unknown field 'val_bits' specified in initializer
drivers/mfd/max77693.c:105: warning: excess elements in struct initializer
drivers/mfd/max77693.c:105: warning: (near initialization for 'max77693_regmap_config')
drivers/mfd/max77693.c:106: error: unknown field 'max_register' specified in initializer
drivers/mfd/max77693.c:106: warning: excess elements in struct initializer
drivers/mfd/max77693.c:106: warning: (near initialization for 'max77693_regmap_config')
drivers/mfd/max77693.c: In function 'max77693_i2c_probe':
drivers/mfd/max77693.c:122: error: implicit declaration of function 'devm_regmap_init_i2c'
drivers/mfd/max77693.c:122: warning: assignment makes pointer from integer without a cast

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a8619eb..0323a31 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -456,6 +456,7 @@ config MFD_MAX77693
 	bool "Maxim Semiconductor MAX77693 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
+	select REGMAP_I2C
 	help
 	  Say yes here to support for Maxim Semiconductor MAX77693.
 	  This is a companion Power Management IC with Flash, Haptic, Charger,
-- 
1.7.0.4

