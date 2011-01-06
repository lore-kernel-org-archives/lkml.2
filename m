Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1AFAax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:53 -0500
Received: from kroah.org ([198.145.64.141]:35932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab1AFAaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:52 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:06 2011
Message-Id: <20110106002306.568071683@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yan Li <yan.i.li@intel.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [103/152] Input: synaptics - fix handling of 2-button ClickPads
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yan Li <yan.i.li@intel.com>

commit 3bfa321e662edf90fb8123a02c987c2965fa50bb upstream.

Lenovo S10-3t's ClickPad is a 2-button ClickPad that reports BTN_LEFT
and BTN_RIGHT as normal touchpad, unlike the 1-button ClickPad used in
HP mini 210 that reports solely BTN_MIDDLE.

In 0xc0-cap response, the 1-button ClickPad has the 20-bit set while
2-button ClickPad has the 8-bit set.

This patch makes the kernel only handle 1-button ClickPad specially,
and treat 2-button ClickPad in the same fashion as regular touchpads.

This fixes kernel bug #18122 and MeeGo bug #4807.

Signed-off-by: Yan Li <yan.i.li@intel.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/synaptics.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -51,7 +51,8 @@
 #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
 #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
 #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
-#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
+#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad */
+#define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPad */
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
 
 /* synaptics modes query bits */


