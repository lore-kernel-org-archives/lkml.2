Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765Ab1KCBmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:42:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934750Ab1KCBm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:42:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:47 2011
Message-Id: <20111102222747.289663250@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <jdelvare@suse.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Sebastian Siewior <bigeasy@linutronix.de>
Subject: [082/101] carminefb: Fix module parameters permissions
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit c84c14224bbca6ec60d5851fcc87be0e34df2f44 upstream.

The third parameter of module_param is supposed to be an octal value.
The missing leading "0" causes the following:

$ ls -l /sys/module/carminefb/parameters/
total 0
-rw-rwxr-- 1 root root 4096 Jul  8 08:55 fb_displays
-rw-rwxr-- 1 root root 4096 Jul  8 08:55 fb_mode
-rw-rwxr-- 1 root root 4096 Jul  8 08:55 fb_mode_str

After fixing the perm parameter, we get the expected:

$ ls -l /sys/module/carminefb/parameters/
total 0
-r--r--r-- 1 root root 4096 Jul  8 08:56 fb_displays
-r--r--r-- 1 root root 4096 Jul  8 08:56 fb_mode
-r--r--r-- 1 root root 4096 Jul  8 08:56 fb_mode_str

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/carminefb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/video/carminefb.c
+++ b/drivers/video/carminefb.c
@@ -31,11 +31,11 @@
 #define CARMINEFB_DEFAULT_VIDEO_MODE	1
 
 static unsigned int fb_mode = CARMINEFB_DEFAULT_VIDEO_MODE;
-module_param(fb_mode, uint, 444);
+module_param(fb_mode, uint, 0444);
 MODULE_PARM_DESC(fb_mode, "Initial video mode as integer.");
 
 static char *fb_mode_str;
-module_param(fb_mode_str, charp, 444);
+module_param(fb_mode_str, charp, 0444);
 MODULE_PARM_DESC(fb_mode_str, "Initial video mode in characters.");
 
 /*
@@ -45,7 +45,7 @@ MODULE_PARM_DESC(fb_mode_str, "Initial v
  * 0b010 Display 1
  */
 static int fb_displays = CARMINE_USE_DISPLAY0 | CARMINE_USE_DISPLAY1;
-module_param(fb_displays, int, 444);
+module_param(fb_displays, int, 0444);
 MODULE_PARM_DESC(fb_displays, "Bit mode, which displays are used");
 
 struct carmine_hw {


