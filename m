Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1GJUAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:00:49 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60316 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755824Ab1GJUAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ila0NtTQy9xpCz8japg8t5RW606kZhCrzz42FivYiNFEgRM9GWC3JV1kDwsY41zmwvyeHXODaQkjoOncYNNr6hwjOVxIcH0aLkQG5p+TrMYpz9XLKlkF56c0FVUz+TFI;
Date: Sun, 10 Jul 2011 12:59:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 8/9] media/radio: fix typhoon CONFIG IO PORT
Message-Id: <20110710125917.ff61508d.rdunlap@xenotime.net>
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

Modify radio-typhoon to use HEX_STRING(CONFIG_RADIO_TYPHOON_PORT)
so that the correct IO port value is used.

Fixes the IO port value that is used since this is hex:
CONFIG_RADIO_TYPHOON_PORT=316
but it was being interpreted as decimal instead of hex.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-typhoon.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-typhoon.c
+++ linux-next-20110707/drivers/media/radio/radio-typhoon.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>	/* Modules                        */
 #include <linux/init.h>		/* Initdata                       */
 #include <linux/ioport.h>	/* request_region		  */
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs           */
 #include <linux/io.h>		/* outb, outb_p                   */
 #include <media/v4l2-device.h>
@@ -44,14 +45,16 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
 
 #ifndef CONFIG_RADIO_TYPHOON_PORT
-#define CONFIG_RADIO_TYPHOON_PORT -1
+#define __RADIO_TYPHOON_PORT -1
+#else
+#define __RADIO_TYPHOON_PORT HEX_STRING(CONFIG_RADIO_TYPHOON_PORT)
 #endif
 
 #ifndef CONFIG_RADIO_TYPHOON_MUTEFREQ
 #define CONFIG_RADIO_TYPHOON_MUTEFREQ 0
 #endif
 
-static int io = CONFIG_RADIO_TYPHOON_PORT;
+static int io = __RADIO_TYPHOON_PORT;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
