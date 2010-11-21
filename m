Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab0KUCmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:42:49 -0500
Received: from mail.perches.com ([173.55.12.10]:1739 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab0KUCkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:40 -0500
From: Joe Perches <joe@perches.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 55/62] b43: Use static const
Date: Sat, 20 Nov 2010 18:38:56 -0800
Message-Id: <515c42b1b99e90575869532cfa383cadb7b66515.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
   5502	     56	   1336	   6894	   1aee	drivers/net/wireless/b43/phy_common.o.new
   5511	     56	   1336	   6903	   1af7	drivers/net/wireless/b43/phy_common.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/b43/phy_common.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 7b2ea67..fa7f83f 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -427,9 +427,11 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
 struct b43_c32 b43_cordic(int theta)
 {
-	u32 arctg[] = { 2949120, 1740967, 919879, 466945, 234379, 117304,
-		      58666, 29335, 14668, 7334, 3667, 1833, 917, 458,
-		      229, 115, 57, 29, };
+	static const u32 arctg[] = {
+		2949120, 1740967, 919879, 466945, 234379, 117304,
+		  58666,   29335,  14668,   7334,   3667,   1833,
+		    917,     458,    229,    115,     57,     29,
+	};
 	u8 i;
 	s32 tmp;
 	s8 signx = 1;
-- 
1.7.3.2.245.g03276.dirty

