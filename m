Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1EFMtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:49:47 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38892 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662Ab1EFMtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:49:46 -0400
Message-ID: <4DC3EF5F.1030306@dsn.okisemi.com>
Date: Fri, 06 May 2011 21:53:51 +0900
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: ML netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC: Tomoya Morinaga <tomoya-linux@dsn.okisemi.com>,
        LKML <linux-kernel@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Subject: [PATCH 1/2] PCH_GbE : Fixed the issue of collision detection
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The collision detection setting was invalid.
When collision occurred, because data was not resenr, 
there was an issue to which a transmitting throughput falls.

This patch enables the collision detection.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/net/pch_gbe/pch_gbe_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pch_gbe/pch_gbe_main.c b/drivers/net/pch_gbe/pch_gbe_main.c
index 8300f64..babe663 100644
--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -43,8 +43,7 @@ const char pch_driver_version[] = DRV_VERSION;
 
 #define PCH_GBE_MAC_RGMII_CTRL_SETTING ( \
 	PCH_GBE_CHIP_TYPE_INTERNAL | \
-	PCH_GBE_RGMII_MODE_RGMII   | \
-	PCH_GBE_CRS_SEL              \
+	PCH_GBE_RGMII_MODE_RGMII     \
 	)
 
 /* Ethertype field values */
-- 
1.6.2.5
