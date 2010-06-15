Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0FOACf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:02:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47421 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab0FOACd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:02:33 -0400
Date: Mon, 14 Jun 2010 17:01:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] backlight: fix 88pm860x_bl macro collision
Message-Id: <20100614170122.b44df729.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C16C308.000C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix collision with kernel-supplied #define:

drivers/video/backlight/88pm860x_bl.c:24:1: warning: "CURRENT_MASK" redefined
arch/x86/include/asm/page_64_types.h:6:1: warning: this is the location of the previous definition

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/video/backlight/88pm860x_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-2634-rc5.orig/drivers/video/backlight/88pm860x_bl.c
+++ lnx-2634-rc5/drivers/video/backlight/88pm860x_bl.c
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
