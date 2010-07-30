Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab0G3SNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:13:13 -0400
Received: from kroah.org ([198.145.64.141]:59081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701Ab0G3R5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:48 2010
Message-Id: <20100730175148.397424555@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>, Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [159/205] isdn/gigaset: remove dummy CAPI method implementations
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit e487639dc8ca6bd6c19a4140f45ebc88da56ddd5 upstream.

Dummy implementations for the optional CAPI controller operations
load_firmware and reset_ctr can cause userspace callers to hang
indefinitely. It's better not to implement them at all.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/capi.c |   28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -933,30 +933,6 @@ void gigaset_isdn_stop(struct cardstate
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
@@ -2213,8 +2189,8 @@ int gigaset_isdn_regdev(struct cardstate
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


