Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2IXHUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:20:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:10517 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2IXHUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:20:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,474,1344236400"; 
   d="scan'208,223";a="225855084"
Message-ID: <506009A4.8000202@linux.intel.com>
Date: Mon, 24 Sep 2012 15:20:04 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120306 Thunderbird/3.1.20
MIME-Version: 1.0
To: Takahiroi Shimizu <tshimizu818@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        haicheng.lee@gmail.com
Subject: [PATCH 1/2] Fix build error caused by broken PCH_PTP module dependency.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 1b4ae11bacfd2eedda1fd0e1ce1d37b678e2f009 Mon Sep 17 00:00:00 2001
From: Haicheng Li <haicheng.li@linux.intel.com>
Date: Mon, 24 Sep 2012 15:01:33 +0800
Subject: [PATCH 1/2] Fix build error caused by broken PCH_PTP module dependency.

The .config is:
         CONFIG_PCH_GBE=y
         CONFIG_PCH_PTP=y
         CONFIG_PTP_1588_CLOCK=m

The build error:

drivers/built-in.o: In function `pch_tx_timestamp':
.../pch_gbe_main.c:215: undefined reference to `pch_ch_event_read'
.../pch_gbe_main.c:225: undefined reference to `pch_tx_snap_read'
.../pch_gbe_main.c:231: undefined reference to `pch_ch_event_write'

.../pch_gbe_main.c:170: undefined reference to `pch_ch_event_read'
.../pch_gbe_main.c:175: undefined reference to `pch_src_uuid_lo_read'
.../pch_gbe_main.c:176: undefined reference to `pch_src_uuid_hi_read'
.../pch_gbe_main.c:190: undefined reference to `pch_ch_event_write'
.../pch_gbe_main.c:184: undefined reference to `pch_rx_snap_read'

.../pch_gbe_main.c:267: undefined reference to `pch_ch_control_write'
.../pch_gbe_main.c:271: undefined reference to `pch_ch_control_write'
.../pch_gbe_main.c:275: undefined reference to `pch_ch_control_write'
.../pch_gbe_main.c:281: undefined reference to `pch_ch_control_write'
.../pch_gbe_main.c:283: undefined reference to `pch_set_station_address'
.../pch_gbe_main.c:290: undefined reference to `pch_ch_event_write'

Signed-off-by: Haicheng Li <haicheng.lee@gmail.com>
---
  drivers/net/ethernet/oki-semi/pch_gbe/Kconfig |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig 
b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
index bce0164..9feaf3f 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
@@ -26,7 +26,7 @@ if PCH_GBE
  config PCH_PTP
  	bool "PCH PTP clock support"
  	default n
-	depends on PTP_1588_CLOCK_PCH
+	depends on PTP_1588_CLOCK_PCH = y
  	---help---
  	  Say Y here if you want to use Precision Time Protocol (PTP) in the
  	  driver. PTP is a method to precisely synchronize distributed clocks
-- 
1.7.1

