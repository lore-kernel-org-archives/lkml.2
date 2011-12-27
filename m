Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1L0OHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:07:13 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:35600 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1L0OHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:07:12 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH -next] net: calxeda xgmac ethernet driver add missing HAS_IOMEM dependency
Date: Tue, 27 Dec 2011 15:07:05 +0100
Message-Id: <1324994825-4197-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.7.3
x-cbid: 11122714-8372-0000-0000-00000136F042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix allyesconfig build on architectures without IOMEM:

drivers/net/ethernet/calxeda/xgmac.c:1800:2:
  error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/Kconfig b/drivers/net/ethernet/calxeda/Kconfig
index a52e725..aba435c 100644
--- a/drivers/net/ethernet/calxeda/Kconfig
+++ b/drivers/net/ethernet/calxeda/Kconfig
@@ -1,6 +1,6 @@
 config NET_CALXEDA_XGMAC
 	tristate "Calxeda 1G/10G XGMAC Ethernet driver"
-
+	depends on HAS_IOMEM
 	select CRC32
 	help
 	  This is the driver for the XGMAC Ethernet IP block found on Calxeda
-- 
1.7.7.3

