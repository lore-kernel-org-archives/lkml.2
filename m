Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2HIG5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:57:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab2HIG5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:57:08 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Chris Ball <cjb@laptop.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdio: Fix PM_SLEEP related build warnings
Date: Thu,  9 Aug 2012 08:56:53 +0200
Message-Id: <1344495413-7164-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.4
X-Provags-ID: V02:K0:bsNBf0P5lk40qTurFkGKZyLPgPhKZKRNitkZWnhfndf
 dIItVIc8I8cuPyCnm9lQk9yYuqC6qnvj0BpnQWcGOLAyNyVM7I
 bDx+DOgaETa2xf2QGIEhF+OKCwuS6CuEvD0qPQQe1tkG9eRvYs
 h6SLXLgxf/gbLkd1J1AqF43rgpZrL2RP6a2+C00hwsw2mnenZg
 SnPLbyjBka76yqrctHZWCaseeLOhWt/b7l4Haeahhuja/N5xqw
 5Rm+xJvQ15B6AOkZEGN8Tr95qaUZGc9W/HZIkllhSlAZ8lE7Yt
 dpEAV/ESgZkJz6CMwJzHrPZm6L+rDB0U9B04XOZn7SHHFrDSys
 U0DkDJZ5vBGZl28+vqsoAOfdzmz51DQ7aaFseojWzzaqwK3YzA
 mUlm5I0+5h/g7tSOr/Zb3Z8T1wyrzXL1jhrT+8gHlno0DlvoNY
 aoEPn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power management callbacks defined by SIMPLE_DEV_PM_OPS are only used if
the PM_SLEEP Kconfig symbol has been defined. If not, the compiler will
complain about them being unused.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/mmc/core/sdio_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 236842e..f8f90b4 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -193,11 +193,12 @@ static int sdio_bus_remove(struct device *dev)
 }
 
 #ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int pm_no_operation(struct device *dev)
 {
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops sdio_bus_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
-- 
1.7.11.4

