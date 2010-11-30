Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0K3HoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 02:44:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:28690 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab0K3HoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 02:44:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,279,1288594800"; 
   d="scan'208";a="354841112"
Date: Tue, 30 Nov 2010 15:44:06 +0800
From: Yan Li <yan.i.li@intel.com>
To: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>
Subject: [PATCH v2] Input: Bug 18122 - Support Lenovo S10-3t's 2-button
 ClickPad
Message-ID: <ddb890ce98e91c7422da64168b1624c1e62a02ee.1291101955.git.yan.i.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for kernel bug #18122 and MeeGo bug #4807, version 2.

Lenovo S10-3t's ClickPad is a 2-button ClickPad that reports BTN_LEFT
and BTN_RIGHT as normal touchpad, unlike the 1-button ClickPad used in
HP mini 210 that reports solely BTN_MIDDLE.

Of c0-cap response, the 1-button ClickPad has the 20-bit set while
2-button ClickPad has the 8-bit set.

This patch makes the kernel only handle 1-button ClickPad specially,
and treat 2-button ClickPad as same as other normal touchpads.

Signed-off-by: Yan Li <yan.i.li@intel.com>
---
 drivers/input/mouse/synaptics.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 613a365..20468b6 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -51,7 +51,13 @@
 #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
 #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
 #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
-#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
+/* This macro detects 1-button ClickPad. Of ex0c capacity, if the
+ * 20-bit of ex0c is set the touchpad is a 1-button ClickPad, which
+ * needs special handling because it reports only BTN_MIDDLE.  If the
+ * 8-bit is set it is a 2-button ClickPad which reports BTN_* events
+ * normally and needs no special handling. Therefore this macro
+ * detects 1-button ClickPad only.  */
+#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000)
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
 
 /* synaptics modes query bits */
-- 
1.7.2.3


-- 
Best regards,
Li, Yan

MeeGo Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net
