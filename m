Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0I1RIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:08:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51574 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab0I1RIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cgGy/sKXcTLd2PeMtRu1CelHJ5KTrtA/w2v+FLpShmiWd+4u5XS+zxIOf4rwGkeLNA
         lESfNEYFCFH115M50j12HJVeNRxjGcdsvmvbDPVF3A5bLVOAC/UV9RgmEYnSn9zm6AUb
         ovpc4pTqt0Al7OPkbSm+JncPLT4BxYs03D84E=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] staging: otus: use free_netdev(netdev) instead of kfree()
Date: Tue, 28 Sep 2010 21:08:04 +0400
Message-Id: <1285693685-4721-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freeing netdev without free_netdev() leads to net, tx leaks.
I might lead to dereferencing freed pointer.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

@@
struct net_device* dev;
@@

-kfree(dev)
+free_netdev(dev)

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/otus/usbdrv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index 165a82b..9a5c415 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -690,7 +690,7 @@ void usbdrv_clear_structs(struct net_device *dev)
 
     kfree(macp);
 
-    kfree(dev);
+    free_netdev(dev);
 
 }
 
-- 
1.7.0.4

