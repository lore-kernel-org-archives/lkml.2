Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2HIJck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:32:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2HIJci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:32:38 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Chris Ball <cjb@laptop.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdio: Fix PM_SLEEP related build warnings
Date: Thu,  9 Aug 2012 11:32:21 +0200
Message-Id: <1344504741-12081-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.4
X-Provags-ID: V02:K0:kWtKjZMEbnBuf6NPKZOXWFP6L/wyN2a9OprGof8BCbr
 OhTdVkekP0JSMlk/PpisK3zHmVQQlukykCyDBzXQ6cbfa/nWNR
 OnJK+qWYqb5uBBRBWLFWr5B8DujqmdVmKMGky5n+ar7l0jPWIy
 98I6JSlXdV5rkSHfWpdn5ZLZvjNomQgKF4whLDckc74VjlyXam
 c+sjHVbZh/xkfWkN7JIiyPmxHxZgmbjuabANlv/dTis1D4/axP
 /EedXRFhJ5JSCDM2SeUlyldnPzBL2eC9rFqiliunGNaZ4pxEzU
 p4a1kuIb6yBZK9IpFzMQYPWULfB//ku67Tcp35+LMdlXqpnBsl
 iHSYDNjfvwyYxfB++8IttQqkgkEu1HEUylDfTZLKyFlykYrewx
 oSgEXhb4xjBWkRA9LHDJ7r2cXuZpQA5hevqjLP6DYIGgDKlRUl
 TiFnv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power management callbacks defined by SIMPLE_DEV_PM_OPS are only used if
the PM_SLEEP Kconfig symbol has been defined. If not, the compiler will
complain about them being unused. However, since the callback for this
driver doesn't do anything it can just as well be dropped.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/mmc/core/sdio_bus.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 236842e..6bf6879 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -193,14 +193,7 @@ static int sdio_bus_remove(struct device *dev)
 }
 
 #ifdef CONFIG_PM
-
-static int pm_no_operation(struct device *dev)
-{
-	return 0;
-}
-
 static const struct dev_pm_ops sdio_bus_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
 	SET_RUNTIME_PM_OPS(
 		pm_generic_runtime_suspend,
 		pm_generic_runtime_resume,
-- 
1.7.11.4

