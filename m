Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab0C3Xzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:55:32 -0400
Received: from kroah.org ([198.145.64.141]:45638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab0C3XTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:15 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:24 2010
Message-Id: <20100330224723.916363336@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Louis Rilling <louis.rilling@kerlabs.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [005/156] tg3: Fix tg3_poll_controller() passing wrong pointer to tg3_interrupt()
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Louis Rilling <Louis.Rilling@kerlabs.com>

commit fe234f0e5cbb880792d2d1ac0743cf8c07e9dde3 upstream.

Commit 09943a1819a240ff4a72f924d0038818fcdd0a90
	Author: Matt Carlson <mcarlson@broadcom.com>
	Date:   Fri Aug 28 14:01:57 2009 +0000

	tg3: Convert ISR parameter to tnapi

forgot to update tg3_poll_controller(), leading to intermittent crashes with
netpoll.

Fix this.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -5223,7 +5223,7 @@ static void tg3_poll_controller(struct n
 	struct tg3 *tp = netdev_priv(dev);
 
 	for (i = 0; i < tp->irq_cnt; i++)
-		tg3_interrupt(tp->napi[i].irq_vec, dev);
+		tg3_interrupt(tp->napi[i].irq_vec, &tp->napi[i]);
 }
 #endif
 


