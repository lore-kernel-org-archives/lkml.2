Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2FNCMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:12:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:44704 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2FNCMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:12:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1339639959!9438789!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] staging: comedi: me4000: remove PORT_PDEBUG macro
Date: Wed, 13 Jun 2012 19:12:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131912.36216.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PORT_PDEBUG macro is used to output the result of every port
io operation. This shouldn't be in a mainline driver. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/me4000.c |    4 ----
 drivers/staging/comedi/drivers/me4000.h |    8 --------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index f5a0bcf..ddb9384 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -111,14 +111,12 @@ static int ai_write_chanlist(struct comedi_device *dev,
 static inline void me4000_outb(struct comedi_device *dev, unsigned char value,
 			       unsigned long port)
 {
-	PORT_PDEBUG("--> 0x%02X port 0x%04lX\n", value, port);
 	outb(value, port);
 }
 
 static inline void me4000_outl(struct comedi_device *dev, unsigned long value,
 			       unsigned long port)
 {
-	PORT_PDEBUG("--> 0x%08lX port 0x%04lX\n", value, port);
 	outl(value, port);
 }
 
@@ -127,7 +125,6 @@ static inline unsigned long me4000_inl(struct comedi_device *dev,
 {
 	unsigned long value;
 	value = inl(port);
-	PORT_PDEBUG("<-- 0x%08lX port 0x%04lX\n", value, port);
 	return value;
 }
 
@@ -136,7 +133,6 @@ static inline unsigned char me4000_inb(struct comedi_device *dev,
 {
 	unsigned char value;
 	value = inb(port);
-	PORT_PDEBUG("<-- 0x%08X port 0x%04lX\n", value, port);
 	return value;
 }
 
diff --git a/drivers/staging/comedi/drivers/me4000.h b/drivers/staging/comedi/drivers/me4000.h
index 7087da2..d9ee3fb 100644
--- a/drivers/staging/comedi/drivers/me4000.h
+++ b/drivers/staging/comedi/drivers/me4000.h
@@ -28,17 +28,9 @@
   Debug section
   ===========================================================================*/
 
-#undef ME4000_PORT_DEBUG	/*  Debug port access */
 #undef ME4000_ISR_DEBUG		/*  Debug the interrupt service routine */
 #undef ME4000_DEBUG		/*  General purpose debug masseges */
 
-#ifdef ME4000_PORT_DEBUG
-#undef PORT_PDEBUG
-#define PORT_PDEBUG(fmt, args...) printk(KERN_DEBUG"comedi%d: me4000: " fmt, dev->minor,  ##args)
-#else
-#define PORT_PDEBUG(fmt, args...)	/*  no debugging, do nothing */
-#endif
-
 #ifdef ME4000_ISR_DEBUG
 #undef ISR_PDEBUG
 #define ISR_PDEBUG(fmt, args...) printk(KERN_DEBUG"comedi%d: me4000: " fmt, dev->minor,  ##args)
-- 
1.7.7

