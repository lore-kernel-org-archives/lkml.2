Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1DTIzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:55:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59105 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1DTIzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=czf16BeNA6AWIv0HCC6AfXoiCkSpezz16bFWwqOKpJRb7yJUM4H0+cSy3hxQOt9Lem
         IcImzg2HlmqdJZTjnTtpNLCU3H3FjQ1zrUPjzfvOQBvp94mGiM3aD1DjgJl6fWHmPEfP
         B8OnO/logPk0EJORXEbepCjgwtzQPaAB+dUCw=
From: Andrea Galbusera <gizero@gmail.com>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>
Cc: linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrea Galbusera <gizero@gmail.com>
Subject: [PATCH 1/1] powerpc: Fix multicast problem in fs_enet driver
Date: Wed, 20 Apr 2011 10:55:19 +0200
Message-Id: <1303289719-16913-1-git-send-email-gizero@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mac-fec.c was setting individual UDP address registers instead of multicast
group address registers when joining a multicast group.
This prevented from correctly receiving UDP multicast packets.
According to datasheet, replaced hash_table_high and hash_table_low
with grp_hash_table_high and grp_hash_table_low respectively.

Tested on a MPC5121 based board.

Signed-off-by: Andrea Galbusera <gizero@gmail.com>
---
 drivers/net/fs_enet/mac-fec.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/fs_enet/mac-fec.c b/drivers/net/fs_enet/mac-fec.c
index 61035fc..b9fbc83 100644
--- a/drivers/net/fs_enet/mac-fec.c
+++ b/drivers/net/fs_enet/mac-fec.c
@@ -226,8 +226,8 @@ static void set_multicast_finish(struct net_device *dev)
 	}
 
 	FC(fecp, r_cntrl, FEC_RCNTRL_PROM);
-	FW(fecp, hash_table_high, fep->fec.hthi);
-	FW(fecp, hash_table_low, fep->fec.htlo);
+	FW(fecp, grp_hash_table_high, fep->fec.hthi);
+	FW(fecp, grp_hash_table_low, fep->fec.htlo);
 }
 
 static void set_multicast_list(struct net_device *dev)
@@ -273,8 +273,8 @@ static void restart(struct net_device *dev)
 	/*
 	 * Reset all multicast.
 	 */
-	FW(fecp, hash_table_high, fep->fec.hthi);
-	FW(fecp, hash_table_low, fep->fec.htlo);
+	FW(fecp, grp_hash_table_high, fep->fec.hthi);
+	FW(fecp, grp_hash_table_low, fep->fec.htlo);
 
 	/*
 	 * Set maximum receive buffer size.
-- 
1.7.0.4

