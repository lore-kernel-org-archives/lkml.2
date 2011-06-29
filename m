Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab1F2FJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:09:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1F2FIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:08:01 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 01/12] Input: synaptics - cleanup 0x0c query documentation
Date: Wed, 29 Jun 2011 13:07:11 +0800
Message-Id: <1309324042-22943-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Convert some spaces to tabs.
Reorder defines to match bit ordering.
Add defines for all bits.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.h |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 7453938..34bedde 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -66,18 +66,24 @@
  * 1	0x60	multifinger mode	identifies firmware finger counting
  *					(not reporting!) algorithm.
  *					Not particularly meaningful
- * 1	0x80    covered pad		W clipped to 14, 15 == pad mostly covered
- * 2	0x01    clickpad bit 1		2-button ClickPad
- * 2	0x02    deluxe LED controls	touchpad support LED commands
+ * 1	0x80	covered pad		W clipped to 14, 15 == pad mostly covered
+ * 2	0x01	clickpad bit 1		2-button ClickPad
+ * 2	0x02	deluxe LED controls	touchpad support LED commands
  *					ala multimedia control bar
  * 2	0x04	reduced filtering	firmware does less filtering on
  *					position data, driver should watch
  *					for noise.
  */
-#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad */
-#define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPad */
+#define SYN_CAP_ADJ_THRESHOLD(ex0c)	((ex0c) & 0x010000)
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
+#define SYN_CAP_CLEARPAD(ex0c)		((ex0c) & 0x040000)
 #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
+#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad */
+#define SYN_CAP_MULTIFINGER_MODE(ex0c)	((ex0c) & 0x600000)
+#define SYN_CAP_COVERED_PAD(ex0c)	((ex0c) & 0x800000)
+#define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPad */
+#define SYN_CAP_DELUXE_LED(ex0c)	((ex0c) & 0x000200)
+#define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
-- 
1.7.3.1

