Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1GJUC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:02:27 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:43466 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755399Ab1GJUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=imORjwf6DtvHEI7Tm/xKSNFxSsioeBG4MxKZ8cohndIxoQLjb+/k483fxW6hE/Baa08i5CQJCk9+vpeJDMoH4fLDvmSAETy5GnZ9VOkf+jgyOwP6wXRudsr0tnQD/c+c;
Date: Sun, 10 Jul 2011 12:53:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 2/9] media/radio: fix aimslab CONFIG IO PORT
Message-Id: <20110710125356.b6cb17c2.rdunlap@xenotime.net>
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

Modify radio-aimslab to use HEX_STRING(CONFIG_RADIO_RTRACK_PORT)
so that the correct IO port value is used.

Fixes this error message when CONFIG_RADIO_RTRACK_PORT=20f:
drivers/media/radio/radio-aimslab.c:49:17: error: invalid suffix "f" on integer constant

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-aimslab.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-aimslab.c
+++ linux-next-20110707/drivers/media/radio/radio-aimslab.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/delay.h>	/* msleep			*/
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
@@ -43,10 +44,12 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.3");
 
 #ifndef CONFIG_RADIO_RTRACK_PORT
-#define CONFIG_RADIO_RTRACK_PORT -1
+#define __RADIO_RTRACK_PORT -1
+#else
+#define __RADIO_RTRACK_PORT HEX_STRING(CONFIG_RADIO_RTRACK_PORT)
 #endif
 
-static int io = CONFIG_RADIO_RTRACK_PORT;
+static int io = __RADIO_RTRACK_PORT;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
