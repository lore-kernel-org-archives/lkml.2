Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab0DCFAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 01:00:49 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55390 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750883Ab0DCFAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 01:00:47 -0400
Date: Sat, 3 Apr 2010 07:00:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc: bernie@plugable.com, amit.kucheria@canonical.com
Subject: staging/udlfb: cleanups
Message-ID: <20100403050037.GA31000@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up udlfb a tiny bit.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/udlfb/udlfb.c b/drivers/staging/udlfb/udlfb.c
index 8f6223c..647e801 100644
--- a/drivers/staging/udlfb/udlfb.c
+++ b/drivers/staging/udlfb/udlfb.c
@@ -57,17 +57,17 @@ static struct usb_device_id id_table[] = {
 MODULE_DEVICE_TABLE(usb, id_table);
 
 #ifndef CONFIG_FB_DEFERRED_IO
-#warning message "kernel FB_DEFFERRED_IO option to support generic fbdev apps"
+#warning Please set CONFIG_FB_DEFFERRED_IO option to support generic fbdev apps
 #endif
 
 #ifndef CONFIG_FB_SYS_IMAGEBLIT
 #ifndef CONFIG_FB_SYS_IMAGEBLIT_MODULE
-#warning message "FB_SYS_* in kernel or module option to support fb console"
+#warning Please set CONFIG_FB_SYS_IMAGEBLIT option to support fb console
 #endif
 #endif
 
 #ifndef CONFIG_FB_MODE_HELPERS
-#warning message "kernel FB_MODE_HELPERS required. Expect build break"
+#warning CONFIG_FB_MODE_HELPERS required. Expect build break
 #endif
 
 /* dlfb keeps a list of urbs for efficient bulk transfers */
@@ -365,32 +365,32 @@ static int dlfb_trim_hline(const u8 *bback, const u8 **bfront, int *width_bytes)
 }
 
 /*
-Render a command stream for an encoded horizontal line segment of pixels.
-
-A command buffer holds several commands.
-It always begins with a fresh command header
-(the protocol doesn't require this, but we enforce it to allow
-multiple buffers to be potentially encoded and sent in parallel).
-A single command encodes one contiguous horizontal line of pixels
-
-The function relies on the client to do all allocation, so that
-rendering can be done directly to output buffers (e.g. USB URBs).
-The function fills the supplied command buffer, providing information
-on where it left off, so the client may call in again with additional
-buffers if the line will take several buffers to complete.
-
-A single command can transmit a maximum of 256 pixels,
-regardless of the compression ratio (protocol design limit).
-To the hardware, 0 for a size byte means 256
-
-Rather than 256 pixel commands which are either rl or raw encoded,
-the rlx command simply assumes alternating raw and rl spans within one cmd.
-This has a slightly larger header overhead, but produces more even results.
-It also processes all data (read and write) in a single pass.
-Performance benchmarks of common cases show it having just slightly better
-compression than 256 pixel raw -or- rle commands, with similar CPU consumpion.
-But for very rl friendly data, will compress not quite as well.
-*/
+ * Render a command stream for an encoded horizontal line segment of pixels.
+ *
+ * A command buffer holds several commands.
+ * It always begins with a fresh command header
+ * (the protocol doesn't require this, but we enforce it to allow
+ * multiple buffers to be potentially encoded and sent in parallel).
+ * A single command encodes one contiguous horizontal line of pixels
+ *
+ * The function relies on the client to do all allocation, so that
+ * rendering can be done directly to output buffers (e.g. USB URBs).
+ * The function fills the supplied command buffer, providing information
+ * on where it left off, so the client may call in again with additional
+ * buffers if the line will take several buffers to complete.
+ *
+ * A single command can transmit a maximum of 256 pixels,
+ * regardless of the compression ratio (protocol design limit).
+ * To the hardware, 0 for a size byte means 256
+ * 
+ * Rather than 256 pixel commands which are either rl or raw encoded,
+ * the rlx command simply assumes alternating raw and rl spans within one cmd.
+ * This has a slightly larger header overhead, but produces more even results.
+ * It also processes all data (read and write) in a single pass.
+ * Performance benchmarks of common cases show it having just slightly better
+ * compression than 256 pixel raw -or- rle commands, with similar CPU consumpion.
+ * But for very rl friendly data, will compress not quite as well.
+ */
 static void dlfb_compress_hline(
 	const uint16_t **pixel_start_ptr,
 	const uint16_t *const pixel_end,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
