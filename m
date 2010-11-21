Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0KUCm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:42:27 -0500
Received: from mail.perches.com ([173.55.12.10]:1751 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab0KUCkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:45 -0500
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 58/62] ray_cs: Use static const
Date: Sat, 20 Nov 2010 18:38:59 -0800
Message-Id: <e530e506090e3de049ea79098ccaa7665575db52.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  42607	   3581	   8536	  54724	   d5c4	drivers/net/wireless/ray_cs.o.new
  42603	   3585	   8536	  54724	   d5c4	drivers/net/wireless/ray_cs.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ray_cs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 97007d9..2b1cbba 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2286,8 +2286,8 @@ static void untranslate(ray_dev_t *local, struct sk_buff *skb, int len)
 	struct ethhdr *peth;
 	UCHAR srcaddr[ADDRLEN];
 	UCHAR destaddr[ADDRLEN];
-	static UCHAR org_bridge[3] = { 0, 0, 0xf8 };
-	static UCHAR org_1042[3] = { 0, 0, 0 };
+	static const UCHAR org_bridge[3] = { 0, 0, 0xf8 };
+	static const UCHAR org_1042[3] = { 0, 0, 0 };
 
 	memcpy(destaddr, ieee80211_get_DA(pmac), ADDRLEN);
 	memcpy(srcaddr, ieee80211_get_SA(pmac), ADDRLEN);
-- 
1.7.3.2.245.g03276.dirty

