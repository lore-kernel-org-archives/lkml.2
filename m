Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab0JTLBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:01:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42665 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JTLBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=T1nGPx/IisqRQE2rX4OEbYtrlkWHNJhSBD7ib6O6x3/vKUNj+cJhGUy2/4a5d6QBZD
         A3ZrTm4wuuyffygSlKW+pT4Fe5AM12jJXWh4bj9R/xowIAVvXavSf8VpN7+wgsVgjREz
         xjCLRTuFj3yNQSkcA87lqYYv1VvwcnwIDB+R0=
MIME-Version: 1.0
Date: Wed, 20 Oct 2010 17:01:32 +0600
Message-ID: <AANLkTi=re9k9CeCNM-omzEBJy1c4RFQ1dsJQZ-hdaxuD@mail.gmail.com>
Subject: [PATCH] net, sch_generic.c : Fix unused variable warning.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fixes the following warning. Althrough the warning looks bogus.

net/sched/sch_generic.c: In function ‘dev_watchdog’:
net/sched/sch_generic.c:256: warning: unused variable ‘drivername’


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus-rc8/net/sched/sch_generic.c	2010-10-20 16:44:10.000000000 +0600
+++ rakib-rc8/net/sched/sch_generic.c	2010-10-20 16:44:51.000000000 +0600
@@ -253,7 +253,7 @@ static void dev_watchdog(unsigned long a
 			}

 			if (some_queue_timedout) {
-				char drivername[64];
+				char drivername[64] __maybe_unused;
 				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue
%u timed out\n",
 				       dev->name, netdev_drivername(dev, drivername, 64), i);
 				dev->netdev_ops->ndo_tx_timeout(dev);
