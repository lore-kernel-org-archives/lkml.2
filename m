Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab0IGPZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:25:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54138 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab0IGPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OCciRJzfOXpGKsowi+CiGfTlwcyhqOIVPL40/QfmGKIjo+mI2SilrHgEiBLVwiOH9A
         6QuQgC+FVHPHxl3DididTP0jbvnjPHjnmZLgRLlQzukhxfwZilCgOQ4pkL6W9hZJDkRr
         SVA/O3h9y64GPXGtXO7x5JkjXCNeNHLCJo7uw=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if data is transfered over
Date: Tue,  7 Sep 2010 23:23:33 +0800
Message-Id: <1283873014-32511-6-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Complete the current request only if the data transfer is over.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Felipe Balbi <me@felipebalbi.com>
Cc: Anand Gadiyar <gadiyar@ti.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/usb/musb/musb_gadget.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index f3ee04f..fa826f9 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -501,14 +501,14 @@ void musb_g_tx(struct musb *musb, u8 epnum)
 				request->zero = 0;
 			}
 
-			/* ... or if not, then complete it. */
-			musb_g_giveback(musb_ep, request, 0);
-
-			request = musb_ep->desc ? next_request(musb_ep) : NULL;
-			if (!request) {
-				DBG(4, "%s idle now\n",
-					musb_ep->end_point.name);
-				return;
+			if (request->actual == request->length) {
+				musb_g_giveback(musb_ep, request, 0);
+				request = musb_ep->desc ? next_request(musb_ep) : NULL;
+				if (!request) {
+					DBG(4, "%s idle now\n",
+						musb_ep->end_point.name);
+					return;
+				}
 			}
 		}
 
-- 
1.6.2.5

