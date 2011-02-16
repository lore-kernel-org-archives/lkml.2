Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1BPAYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:12 -0500
Received: from kroah.org ([198.145.64.141]:49590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab1BPAYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:46 2011
Message-Id: <20110216001446.250560998@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [211/272] backlight: fix 88pm860x_bl macro collision
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit 2550326ac7a062fdfc204f9a3b98bdb9179638fc upstream.

Fix collision with kernel-supplied #define:

  drivers/video/backlight/88pm860x_bl.c:24:1: warning: "CURRENT_MASK" redefined
  arch/x86/include/asm/page_64_types.h:6:1: warning: this is the location of the previous definition

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/backlight/88pm860x_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -21,7 +21,7 @@
 #define MAX_BRIGHTNESS		(0xFF)
 #define MIN_BRIGHTNESS		(0)
 
-#define CURRENT_MASK		(0x1F << 1)
+#define CURRENT_BITMASK		(0x1F << 1)
 
 struct pm860x_backlight_data {
 	struct pm860x_chip *chip;
@@ -85,7 +85,7 @@ static int pm860x_backlight_set(struct b
 	if ((data->current_brightness == 0) && brightness) {
 		if (data->iset) {
 			ret = pm860x_set_bits(data->i2c, wled_idc(data->port),
-					      CURRENT_MASK, data->iset);
+					      CURRENT_BITMASK, data->iset);
 			if (ret < 0)
 				goto out;
 		}


