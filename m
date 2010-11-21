Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab0KUCs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:48:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1683 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab0KUCkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:10 -0500
From: Joe Perches <joe@perches.com>
To: Guo-Fu Tseng <cooldavid@cooldavid.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 29/62] jme: Use static const
Date: Sat, 20 Nov 2010 18:38:30 -0800
Message-Id: <fce48d2d72040da35a2b4c4fa29f3376e70b93ff.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  38255	    248	  10408	  48911	   bf0f	drivers/net/jme.o.new
  38252	    248	  10408	  48908	   bf0c	drivers/net/jme.o.old

Change jme_setup_wakeup_frame to take a const *.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/jme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index c57d9a4..d6289fb 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -135,7 +135,7 @@ jme_reset_phy_processor(struct jme_adapter *jme)
 
 static void
 jme_setup_wakeup_frame(struct jme_adapter *jme,
-		u32 *mask, u32 crc, int fnr)
+		       const u32 *mask, u32 crc, int fnr)
 {
 	int i;
 
@@ -163,7 +163,7 @@ jme_setup_wakeup_frame(struct jme_adapter *jme,
 static inline void
 jme_reset_mac_processor(struct jme_adapter *jme)
 {
-	u32 mask[WAKEUP_FRAME_MASK_DWNR] = {0, 0, 0, 0};
+	static const u32 mask[WAKEUP_FRAME_MASK_DWNR] = {0, 0, 0, 0};
 	u32 crc = 0xCDCDCDCD;
 	u32 gpreg0;
 	int i;
-- 
1.7.3.2.245.g03276.dirty

