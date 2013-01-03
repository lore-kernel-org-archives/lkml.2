Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3ACOVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:21:51 -0500
Received: from mout.gmx.net ([212.227.15.19]:61124 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab3ACOVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:21:48 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18T+yQjoV8Ts2NHzVpE70UTBy1NSOlIM/wNNS8jN/
	KAvsAMCsiOGwwp
From: Peter Huewe <peterhuewe@gmx.de>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        kbuild@01.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH net-next/master] ethernet/broadcom/tg3: Fix sparse warning: constant 0x7fffffffffffffff is so big it is long long
Date: Thu,  3 Jan 2013 15:23:50 +0100
Message-Id: <1357223030-29155-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <50beaf6a.HF5L0P4z6BqrUx/x%fengguang.wu@intel.com>
References: <50beaf6a.HF5L0P4z6BqrUx/x%fengguang.wu@intel.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse complains that:
drivers/net/ethernet/broadcom/tg3.c:5670:55: sparse: constant
0x7fffffffffffffff is so big it is long long (on x86/32 bit)

so we suffix the constant with LL in the header file.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/net/ethernet/broadcom/tg3.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index d330e81..247d954 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -774,7 +774,7 @@
 #define  SG_DIG_AUTONEG_ERROR		 0x00000001
 #define TG3_TX_TSTAMP_LSB		0x000005c0
 #define TG3_TX_TSTAMP_MSB		0x000005c4
-#define  TG3_TSTAMP_MASK		 0x7fffffffffffffff
+#define  TG3_TSTAMP_MASK		 0x7fffffffffffffffLL
 /* 0x5c8 --> 0x600 unused */
 #define MAC_TX_MAC_STATE_BASE		0x00000600 /* 16 bytes */
 #define MAC_RX_MAC_STATE_BASE		0x00000610 /* 20 bytes */
-- 
1.7.8.6

