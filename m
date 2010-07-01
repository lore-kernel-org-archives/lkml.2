Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0GANRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:17:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47908 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0GANRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TkTp9QMnQpX6B0O7U7RV65VnE4D8/2TOdEDaFd5mdK9NMVrPu07VTDz4M9gQefG3wK
         9yXVWTR1bDpAFr8yShrXkQ1IK6eybbfsRTl4ePz75aa4DREMVBocFqDuSntXC8bnrp0f
         ve0L/Q9ghYiE2qw/pT9j16IINfAmHBo0RTGco=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       Henk de Groot <pe1dnn@amsat.org>,
       Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 23/25] staging/wlags49_h2: remove casts from void*
Date: Thu,  1 Jul 2010 17:16:57 +0400
Message-Id: <1277990218-22851-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/wlags49_h2/wl_netdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 1aa61db..df38402 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -1905,8 +1905,8 @@ int wl_rx_dma( struct net_device *dev )
     DBG_FUNC("wl_rx")
     DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
 
-    if((( lp = (struct wl_private *)dev->priv ) != NULL ) &&
-          !( lp->flags & WVLAN2_UIL_BUSY )) {
+    lp = dev->priv;
+    if (lp && !(lp->flags & WVLAN2_UIL_BUSY)) {
 
 #ifdef USE_RTS
         if( lp->useRTS == 1 ) {
-- 
1.7.0.4

