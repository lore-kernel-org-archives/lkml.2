Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2JQEw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:52:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53456 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2JQEw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:52:27 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-79-507e398a46ba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: ili9320: add missing SPI dependency
Date: Wed, 17 Oct 2012 13:52:26 +0900
Message-id: <002f01cdac23$342623c0$9c726b40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2sIzQGwZikTWlAT6yrWuU5OLTHbQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd0uy7oAg+YGGYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx7Np69oIp7BVHLv1nbGB8xdrFyMkhIWAicf/xOUYIW0ziwr31
	bF2MXBxCAosYJRYd2MIK4cxmkmhftIkJpIpNQE3iy5fD7CC2iECERPOMWcwgNrNAocSd349Z
	QGxhAXuJRd/egE1lEVCVmPr4Adg2XgFbidufb7BB2IISPybfY4Ho1ZLYvK2JFcKWl9i85i3Q
	TA6gi9QlHv3VBTFFBPQkNu8QgagQkdj34h3jBEaBWUgGzUIyaBaSQbOQtCxgZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERyWz6R3MK5qsDjEKMDBqMTDG7C0NkCINbGsuDL3EKMEB7OS
	CK95I1CINyWxsiq1KD++qDQntfgQozQHi5I4b7NHSoCQQHpiSWp2ampBahFMlomDU6qB0TYv
	9PoplYr58tbl7yeFaLe+Pb6vvlTmvkC/Y5xY2OO5U3bGlkz1/btU4cyPnhvHliW7eL6zeSkR
	zcmcovFYNibb76TViSwhnj92s+UXvOhnXXx+8vSpa/cufCLPffFwb9XlY//T5vzy/m7FY+gQ
	vVo943O03QrLiRZvSg/1cB5y/Xh0kuOaiUosxRmJhlrMRcWJAAJGH1FHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds this missing SPI dependency and prevents
the driver from buiding without SPI, because funtion of
spi driver is used in this driver.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 drivers/video/backlight/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index c101697..765a945 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -60,7 +60,8 @@ config LCD_LTV350QV
 	  The LTV350QV panel is present on all ATSTK1000 boards.
 
 config LCD_ILI9320
-	tristate
+	tristate "ILI Technology ILI9320 controller support"
+	depends on SPI
 	help
 	  If you have a panel based on the ILI9320 controller chip
 	  then say y to include a power driver for it.
-- 
1.7.1


