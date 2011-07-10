Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1GJUCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:02:11 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:50836 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754927Ab1GJUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OeKicvqeIQnURdpOo9Dh30NkgAswW/obQ/jFl/0P9ikbJOqvc838rfxHpg5Wet4Qih+OHx+5kYzJFaPLFl2m6rHXhQ/KBDB0JQQaJZv/Y96se/N+uEOuChlWkwoQoocr;
Date: Sun, 10 Jul 2011 12:54:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 3/9] media/radio: fix aztech CONFIG IO PORT
Message-Id: <20110710125454.acdc6758.rdunlap@xenotime.net>
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Modify radio-aztech to use HEX_STRING(CONFIG_RADIO_AZTECH_PORT)
so that the correct IO port value is used.

Fixes the IO port value that is used since this is hex:
CONFIG_RADIO_AZTECH_PORT=350
but it was being interpreted as decimal instead of hex.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-aztech.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-aztech.c
+++ linux-next-20110707/drivers/media/radio/radio-aztech.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/delay.h>	/* udelay			*/
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
@@ -42,10 +43,12 @@ MODULE_VERSION("0.0.3");
 /* acceptable ports: 0x350 (JP3 shorted), 0x358 (JP3 open) */
 
 #ifndef CONFIG_RADIO_AZTECH_PORT
-#define CONFIG_RADIO_AZTECH_PORT -1
+#define __RADIO_AZTECH_PORT -1
+#else
+#define __RADIO_AZTECH_PORT HEX_STRING(CONFIG_RADIO_AZTECH_PORT)
 #endif
 
-static int io = CONFIG_RADIO_AZTECH_PORT;
+static int io = __RADIO_AZTECH_PORT;
 static int radio_nr = -1;
 static int radio_wait_time = 1000;
 
