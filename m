Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab0JZKV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:21:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60741 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab0JZKSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:17 -0400
From: Julia Lawall <julia@diku.dk>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/14] drivers/usb/gadget/amd5536udc.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:31 +0200
Message-Id: <1288088743-3725-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/gadget/amd5536udc.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 9034e03..f8dd726 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3359,7 +3359,6 @@ static int udc_probe(struct udc *dev)
 	dev_set_name(&dev->gadget.dev, "gadget");
 	dev->gadget.dev.release = gadget_release;
 	dev->gadget.name = name;
-	dev->gadget.name = name;
 	dev->gadget.is_dualspeed = 1;
 
 	/* init registers, interrupts, ... */

