Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1K0SX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 13:23:28 -0500
Received: from gimli.pxnet.com ([89.1.7.7]:58209 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1K0SX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 13:23:26 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Nov 2011 13:23:26 EST
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 27 Nov 2011 18:39:22 +0100
Message-ID: <20111127-patch-gigaset-01.tilman@imap.cc>
Subject: [PATCH] isdn/gigaset: report ISDN4Linux interface only once
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the "ISDN4Linux interface" message from device registration,
where it is emitted for each device, to driver registration, where
it is emitted only once, for consistency with the CAPI variant.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/i4l.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/gigaset/i4l.c b/drivers/isdn/gigaset/i4l.c
index 04231cb..1793ba1 100644
--- a/drivers/isdn/gigaset/i4l.c
+++ b/drivers/isdn/gigaset/i4l.c
@@ -624,8 +624,6 @@ int gigaset_isdn_regdev(struct cardstate *cs, const char *isdnid)
 {
 	isdn_if *iif;
 
-	pr_info("ISDN4Linux interface\n");
-
 	iif = kmalloc(sizeof *iif, GFP_KERNEL);
 	if (!iif) {
 		pr_err("out of memory\n");
@@ -684,6 +682,7 @@ void gigaset_isdn_unregdev(struct cardstate *cs)
  */
 void gigaset_isdn_regdrv(void)
 {
+	pr_info("ISDN4Linux interface\n");
 	/* nothing to do */
 }
 
-- 
1.7.3.4

