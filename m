Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1GJUBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:01:07 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39296 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755984Ab1GJUAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JyOnc3bM1eC3Z46Ex6JAHd1trv4wHL3OYf8xbg2ESTTFjf9GU2zw/Y4JGd0S7q5ZQ0046R7v6ZVtnszdPD+TYscdnrcJCMl/VVfG3sdo+Npe8cEBIGXEXfAh2scCKHPB;
Date: Sun, 10 Jul 2011 12:59:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 9/9] media/radio: fix zoltrix CONFIG IO PORT
Message-Id: <20110710125957.87666000.rdunlap@xenotime.net>
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

Modify radio-zoltrix to use HEX_STRING(CONFIG_RADIO_ZOLTRIX_PORT)
so that the correct IO port value is used.

Fixes this error message when CONFIG_RADIO_ZOLTRIX_PORT=20c:
drivers/media/radio/radio-zoltrix.c:51:17: error: invalid suffix "c" on integer constant

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-zoltrix.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-zoltrix.c
+++ linux-next-20110707/drivers/media/radio/radio-zoltrix.c
@@ -33,6 +33,7 @@
 #include <linux/init.h>		/* Initdata                       */
 #include <linux/ioport.h>	/* request_region		  */
 #include <linux/delay.h>	/* udelay, msleep                 */
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs           */
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p                   */
@@ -45,10 +46,12 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.3");
 
 #ifndef CONFIG_RADIO_ZOLTRIX_PORT
-#define CONFIG_RADIO_ZOLTRIX_PORT -1
+#define __RADIO_ZOLTRIX_PORT -1
+#else
+#define __RADIO_ZOLTRIX_PORT HEX_STRING(CONFIG_RADIO_ZOLTRIX_PORT)
 #endif
 
-static int io = CONFIG_RADIO_ZOLTRIX_PORT;
+static int io = __RADIO_ZOLTRIX_PORT;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
