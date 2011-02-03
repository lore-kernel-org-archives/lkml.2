Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1BCUPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:15:00 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10902 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1BCUO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:14:59 -0500
Date: Thu, 3 Feb 2011 21:14:01 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-wireless@vger.kernel.org
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@adurom.com>
Subject: [PATCH] wireless, wl1251: Fix potential NULL pointer dereference in
 wl1251_op_bss_info_changed()
Message-ID: <alpine.LNX.2.00.1102032100460.15101@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/net/wireless/wl1251/main.c:wl1251_op_bss_info_changed() we make 
a call to ieee80211_beacon_get() which may return NULL, but we do not 
check the return value before dereferencing the pointer.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 012e1a4..40372ba 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -1039,6 +1039,9 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_BEACON) {
 		beacon = ieee80211_beacon_get(hw, vif);
+		if (!beacon)
+			goto out_sleep;
+
 		ret = wl1251_cmd_template_set(wl, CMD_BEACON, beacon->data,
 					      beacon->len);
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

