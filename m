Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0GFAS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:18:57 -0400
Received: from gimli.pxnet.com ([89.1.7.7]:41946 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab0GFASy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:18:54 -0400
Subject: [PATCH 01/11] isdn/gigaset: adjust usb_gigaset tty write buffer limit
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20100705-patch-gigaset-01.tilman@imap.cc>
In-Reply-To: <20100705-patch-gigaset-00.tilman@imap.cc>
References: <20100705-patch-gigaset-00.tilman@imap.cc>
Date: Tue,  6 Jul 2010 02:18:37 +0200 (CEST)
X-Spam-Score: -2.021 () AWL,BAYES_00,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb_gigaset driver's write buffer limit was different from those
of the others for no good reason. Set it to the same value, derived
from the Siemens documentation.

Impact: cosmetic
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/usb-gigaset.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
index 76dbb20..f65cf7d 100644
--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -39,7 +39,8 @@ MODULE_PARM_DESC(cidmode, "Call-ID mode");
 #define GIGASET_MODULENAME "usb_gigaset"
 #define GIGASET_DEVNAME    "ttyGU"
 
-#define IF_WRITEBUF 2000	/* arbitrary limit */
+/* length limit according to Siemens 3070usb-protokoll.doc ch. 2.1 */
+#define IF_WRITEBUF 264
 
 /* Values for the Gigaset M105 Data */
 #define USB_M105_VENDOR_ID	0x0681
-- 
1.6.5.3.298.g39add

