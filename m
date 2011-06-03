Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1FCXSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:18:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1FCXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KLVRKgjzeqIDw/u4Fs2gJyC+ChiwLSsbH3KgyanGAGys94bQ1nyqoCSULpwz8RWg5l
         kcU7DJX/4a1O9ELC52cVE355b/rNU+0F4qDYYRjdVDHx1qeDTTe/PtdiTqTuHAGvXP18
         i7EzyJQrIIrt+KrWy9a/SUXYtPYq3PDAZY4/o=
From: Connor Hansen <cmdkhh@gmail.com>
To: hadi@cyberus.ca
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Connor Hansen <cmdkhh@gmail.com>
Subject: [PATCH] sch_generic unused variable warning
Date: Fri,  3 Jun 2011 16:18:26 -0700
Message-Id: <1307143106-14523-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

during randconfig testing net/sched/sch_generic produced
net/sched/sch_generic.c: In function dev_watchdog
net/sched/sch_generic.c:254:10: warning: unused variable drivername

drivername is only used in the scope of the WARN_ONCE

Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
---
 net/sched/sch_generic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index b1721d7..7380da2 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -251,9 +251,8 @@ static void dev_watchdog(unsigned long arg)
 			}
 
 			if (some_queue_timedout) {
-				char drivername[64];
 				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
-				       dev->name, netdev_drivername(dev, drivername, 64), i);
+				       dev->name, netdev_drivername(dev, char drivername[64], 64), i);
 				dev->netdev_ops->ndo_tx_timeout(dev);
 			}
 			if (!mod_timer(&dev->watchdog_timer,
-- 
1.7.4.4

