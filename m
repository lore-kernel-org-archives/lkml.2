Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0FAMXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:23:07 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:45489 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442Ab0FAMXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:23:02 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 18/18] DMAENGINE: ste_dma40: no disabled phy channels on ux500
Date: Tue, 1 Jun 2010 14:22:52 +0200
Message-ID: <1275394972-26911-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Make sure we have no disabled physical channels when we start on
the ux500 machines.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c           |    1 +
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index a001e4c..e2b7c31 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -194,6 +194,7 @@ static struct stedma40_platform_data dma40_plat_data = {
 	.memcpy_conf_phy = &dma40_memcpy_conf_phy,
 	.memcpy_conf_log = &dma40_memcpy_conf_log,
 	.llis_per_log = 8,
+	.disabled_channels = {-1},
 };
 
 struct platform_device u8500_dma40_device = {
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 4d12ea4..5fbde4b 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -148,7 +148,8 @@ struct stedma40_chan_cfg {
  * @memcpy_conf_phy: default configuration of physical channel memcpy
  * @memcpy_conf_log: default configuration of logical channel memcpy
  * @llis_per_log: number of max linked list items per logical channel
- *
+ * @disabled_channels: A vector, ending with -1, that marks physical channels
+ * that are for different reasons not available for the driver.
  */
 struct stedma40_platform_data {
 	u32				 dev_len;
@@ -159,6 +160,7 @@ struct stedma40_platform_data {
 	struct stedma40_chan_cfg	*memcpy_conf_phy;
 	struct stedma40_chan_cfg	*memcpy_conf_log;
 	unsigned int			 llis_per_log;
+	int				 disabled_channels[8];
 };
 
 /**
-- 
1.6.3.3

