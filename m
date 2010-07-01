Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0GANW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:22:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:52434 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0GANWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TVvmixfZkH0ROupbjdz41y7bK0sZ7/6xwtZ39SsN3QrARSN39Q1hMNGVaMBjMytkYE
         S7+coYbGCEfFy1pHdZTuufN03fGlsvcXBsSCEUD7mnzyW/Dz0N0DTK8/VjPHXcsTLuxD
         +HO0igPcezM2OUB+J5VzZCDzX1L8S159HkpXA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bob Beers <bob.beers@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/25] staging/cxt1e1: remove casts from void*
Date: Thu,  1 Jul 2010 17:16:49 +0400
Message-Id: <1277990210-22191-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/cxt1e1/linux.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 134e756..0cd93a1 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -461,7 +461,7 @@ chan_get_stats (struct net_device * ndev)
     {
         struct c4_priv *priv;
 
-        priv = (struct c4_priv *) dev_to_hdlc (ndev)->priv;
+	priv = dev_to_hdlc(ndev)->priv;
         channum = priv->channum;
     }
 #endif
@@ -886,7 +886,7 @@ do_deluser (struct net_device * ndev, int lockit)
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
         priv = DEV_TO_PRIV (ndev);
 #else
-        priv = (struct c4_priv *) dev_to_hdlc (ndev)->priv;
+	priv = dev_to_hdlc(ndev)->priv;
 #endif
         ci = priv->ci;
         channum = priv->channum;
-- 
1.7.0.4

