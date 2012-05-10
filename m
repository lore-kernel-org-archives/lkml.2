Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab2EJHhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:37:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17305 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2EJHhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:37:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 10 May 2012 00:35:08 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC 1/1] Driver Core: don't oops with unregistered driver in driver_find_device()
Date: Thu, 10 May 2012 10:35:02 +0300
Message-ID: <1336635302-29260-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver_find_device() can be called with an unregistered driver. Need
to check driver_private to see if it's populated or not, especially
under deferrable probe.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
In [PATCHv5 2/3] ARM: tegra: Add SMMU enabler in AHB:
  http://article.gmane.org/gmane.linux.ports.tegra/4658

"tegra_ahb_driver" may not be populated when it's called.
---
 drivers/base/driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 3ec3896..207c27d 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -80,7 +80,7 @@ struct device *driver_find_device(struct device_driver *drv,
 	struct klist_iter i;
 	struct device *dev;
 
-	if (!drv)
+	if (!drv || !drv->p)
 		return NULL;
 
 	klist_iter_init_node(&drv->p->klist_devices, &i,
-- 
1.7.5.4

