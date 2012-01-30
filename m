Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2A3KBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:01:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58259 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2A3KBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:01:37 -0500
From: "Devendra.Naga" <devendra.aaru@gmail.com>
To: <Larry.Finger@lwfinger.net>, <chaoming_li@realsil.com.cn>,
        <linville@tuxdriver.com>, <paul.gortmaker@windriver.com>,
        <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Devendra.Naga" <devendra.aaru@gmail.com>
Subject: [PATCH 1/1] wireless: in _rtl92c_phy_calculate_bit_shift remove comparing bitmask against 1
Date: Mon, 30 Jan 2012 05:00:55 -0500
Message-Id: <1327917655-6494-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devendra.Naga" <devendra.aaru@gmail.com>

in _rtl92c_phy_calculate_bit_shift everytime the right shifted bitmask
is AND with 1 and compared against 1. i.e.
        if ((bitmask >> i) & 0x1 == 1)
                break;
which in the if condition is anyway becomes a 1 or 0.

Signed-off-by: Devendra.Naga <devendra.aaru@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
index 22e998d..a76b223 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -177,7 +177,7 @@ u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask)
 	u32 i;
 
 	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
+		if ((bitmask >> i) & 0x1)
 			break;
 	}
 	return i;
-- 
1.7.5.4

