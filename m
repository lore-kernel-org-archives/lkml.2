Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0EWLYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 07:24:45 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:56623 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab0EWLY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 07:24:27 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 May 2010 07:24:23 EDT
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 2/2] isdn/gigaset: remove dummy CAPI method implementations
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20100523-patch-gigaset-02.tilman@imap.cc>
In-Reply-To: <20100523-patch-gigaset-00.tilman@imap.cc>
References: <20100523-patch-gigaset-00.tilman@imap.cc>
Date: Sun, 23 May 2010 13:02:38 +0200 (CEST)
X-Spam-Score: -0.898 () AWL,BAYES_20,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dummy implementations for the optional CAPI controller operations
load_firmware and reset_ctr can cause userspace callers to hang
indefinitely. It's better not to implement them at all.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/capi.c |   28 ++--------------------------
 1 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 964a55f..e72f86b 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -933,30 +933,6 @@ void gigaset_isdn_stop(struct cardstate *cs)
  */
 
 /*
- * load firmware
- */
-static int gigaset_load_firmware(struct capi_ctr *ctr, capiloaddata *data)
-{
-	struct cardstate *cs = ctr->driverdata;
-
-	/* AVM specific operation, not needed for Gigaset -- ignore */
-	dev_notice(cs->dev, "load_firmware ignored\n");
-
-	return 0;
-}
-
-/*
- * reset (deactivate) controller
- */
-static void gigaset_reset_ctr(struct capi_ctr *ctr)
-{
-	struct cardstate *cs = ctr->driverdata;
-
-	/* AVM specific operation, not needed for Gigaset -- ignore */
-	dev_notice(cs->dev, "reset_ctr ignored\n");
-}
-
-/*
  * register CAPI application
  */
 static void gigaset_register_appl(struct capi_ctr *ctr, u16 appl,
@@ -2213,8 +2189,8 @@ int gigaset_isdn_regdev(struct cardstate *cs, const char *isdnid)
 	iif->ctr.driverdata    = cs;
 	strncpy(iif->ctr.name, isdnid, sizeof(iif->ctr.name));
 	iif->ctr.driver_name   = "gigaset";
-	iif->ctr.load_firmware = gigaset_load_firmware;
-	iif->ctr.reset_ctr     = gigaset_reset_ctr;
+	iif->ctr.load_firmware = NULL;
+	iif->ctr.reset_ctr     = NULL;
 	iif->ctr.register_appl = gigaset_register_appl;
 	iif->ctr.release_appl  = gigaset_release_appl;
 	iif->ctr.send_message  = gigaset_send_message;
-- 
1.6.5.3.298.g39add

