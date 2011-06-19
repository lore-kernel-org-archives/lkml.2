Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1FSKMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 06:12:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47507 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab1FSKMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 06:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Wmcj/5RrjY7Hr9zledABCdE0IMooIlx3aJR4upHitW/lJRIxt5PtbgFWbkVxeSLqZP
         uH1AqS5/lXK0StBsep7XEPyPgGlD930M+wIZhdLAxJMcWs19fMzqRQuvCI9ccCOH2Rrq
         TawGp67GwCAZDmkqQM5WU2OPgrocl/I98wOWY=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stefan Weil <weil@mail.berlios.de>,
        Xiaochen Wang <wangxiaochen0@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Dan Carpenter <error27@gmail.com>,
        David Chosrova <dada2372@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 2/3] drivers:rtl8192u:remove the use of obsolete create_workqueue in r8192U_core.c
Date: Sun, 19 Jun 2011 18:11:57 +0800
Message-Id: <1308478318-8462-2-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308478318-8462-1-git-send-email-wanlong.gao@gmail.com>
References: <1308478318-8462-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of obsolete create_workqueue(name, 0) interface
in r8192U_core.c, since it has changed.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index e81b8ab..334e078d 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2852,11 +2852,7 @@ static void rtl8192_init_priv_task(struct net_device* dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-#ifdef PF_SYNCTHREAD
-	priv->priv_wq = create_workqueue(DRV_NAME,0);
-#else
 	priv->priv_wq = create_workqueue(DRV_NAME);
-#endif
 
 	INIT_WORK(&priv->reset_wq, rtl8192_restart);
 
-- 
1.7.4.1

