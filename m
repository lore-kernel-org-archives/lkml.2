Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1BBA4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:56:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:54278 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab1BBAoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960753"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: yan.i.li@intel.com, dtor@mail.ru, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [96/139] Input: synaptics - fix handling of 2-button ClickPads
Message-Id: <20110202004454.3C6BE3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/input/mouse/synaptics.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/input/mouse/synaptics.h
===================================================================
--- linux-2.6.35.y.orig/drivers/input/mouse/synaptics.h
+++ linux-2.6.35.y/drivers/input/mouse/synaptics.h
@@ -51,7 +51,8 @@
 #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
 #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
 #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
-#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
+#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad */
+#define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPad */
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
 
 /* synaptics modes query bits */
