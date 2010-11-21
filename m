Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0KUCj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:39:56 -0500
Received: from mail.perches.com ([173.55.12.10]:1631 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab0KUCjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:39:43 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/62] 3c507: Use static const
Date: Sat, 20 Nov 2010 18:38:04 -0800
Message-Id: <1e63ae86560183cec72aa188fc18d84411acdc70.1290305775.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  10001	    400	   2168	  12569	   3119	drivers/net/3c507.o.new
   9981	    420	   2168	  12569	   3119	drivers/net/3c507.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/3c507.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/3c507.c b/drivers/net/3c507.c
index 475a66d..1e94555 100644
--- a/drivers/net/3c507.c
+++ b/drivers/net/3c507.c
@@ -311,8 +311,8 @@ static int mem_start;
 struct net_device * __init el16_probe(int unit)
 {
 	struct net_device *dev = alloc_etherdev(sizeof(struct net_local));
-	static unsigned ports[] = { 0x300, 0x320, 0x340, 0x280, 0};
-	unsigned *port;
+	static const unsigned ports[] = { 0x300, 0x320, 0x340, 0x280, 0};
+	const unsigned *port;
 	int err = -ENODEV;
 
 	if (!dev)
-- 
1.7.3.2.245.g03276.dirty

