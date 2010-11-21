Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab0KUClR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:41:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1762 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab0KUCks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:48 -0500
From: Joe Perches <joe@perches.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 61/62] wl12xx: Use static const
Date: Sat, 20 Nov 2010 18:39:02 -0800
Message-Id: <dd2fadcc20f85cb3da9e11db69353f67cb8ef064.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  13071	     56	   2880	  16007	   3e87	drivers/net/wireless/wl12xx/wl1271_acx.o.old
  13071	     56	   2880	  16007	   3e87	drivers/net/wireless/wl12xx/wl1271_acx.o.new

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index bd7f95f..c688471 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1231,7 +1231,9 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    bool allow_ht_operation)
 {
 	struct wl1271_acx_ht_capabilities *acx;
-	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	static const u8 mac_address[ETH_ALEN] = {
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	};
 	int ret = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx ht capabilities setting");
-- 
1.7.3.2.245.g03276.dirty

