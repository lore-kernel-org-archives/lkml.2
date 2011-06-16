Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab1FPMPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:15:53 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55422 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757727Ab1FPMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:15:47 -0400
Date: Thu, 16 Jun 2011 14:08:01 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Urs Thuermann <urs.thuermann@volkswagen.de>,
        "David S. Miller" <davem@davemloft.net>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 03/11] net/can: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <6c8d043e92e68ab304999fc1a1f7f4c7a04a818e.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited().

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 net/can/af_can.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 094fc53..8ce926d 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -58,6 +58,7 @@
 #include <linux/skbuff.h>
 #include <linux/can.h>
 #include <linux/can/core.h>
+#include <linux/ratelimit.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
@@ -161,8 +162,8 @@ static int can_create(struct net *net, struct socket *sock, int protocol,
 		 * return the error code immediately.  Below we will
 		 * return -EPROTONOSUPPORT
 		 */
-		if (err && printk_ratelimit())
-			printk(KERN_ERR "can: request_module "
+		if (err)
+			printk_ratelimited(KERN_ERR "can: request_module "
 			       "(can-proto-%d) failed.\n", protocol);
 
 		cp = can_get_proto(protocol);
-- 
1.7.4.1

