Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0C3XtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:49:18 -0400
Received: from kroah.org ([198.145.64.141]:45879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab0C3XTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:46 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:44 2010
Message-Id: <20100330224743.729186681@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Barry Song <barry.song@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Wolfgang Grandegger <wg@grandegger.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [036/156] can: fix bfin_can build error after alloc_candev() change
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Barry Song <barry.song@analog.com>

commit e9dcd1613f0ac0b3573b7d813a2c5672cd8302eb upstream.

Looks like commit a6e4bc530403 didn't include updates to drivers so the
Blackfin CAN driver fails to build now.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/can/bfin_can.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/bfin_can.c
+++ b/drivers/net/can/bfin_can.c
@@ -26,6 +26,7 @@
 
 #define DRV_NAME "bfin_can"
 #define BFIN_CAN_TIMEOUT 100
+#define TX_ECHO_SKB_MAX  1
 
 /*
  * transmit and receive channels
@@ -590,7 +591,7 @@ struct net_device *alloc_bfin_candev(voi
 	struct net_device *dev;
 	struct bfin_can_priv *priv;
 
-	dev = alloc_candev(sizeof(*priv));
+	dev = alloc_candev(sizeof(*priv), TX_ECHO_SKB_MAX);
 	if (!dev)
 		return NULL;
 


