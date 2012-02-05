Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2BEW0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:52 -0500
Received: from 1wt.eu ([62.212.114.60]:62024 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab2BEW0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:43 -0500
Message-Id: <20120205220951.503668259@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.de>, Paul Mundt <lethal@linux-sh.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 48/91] carminefb: Fix module parameters permissions
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 3 insertions(+), 3 deletions(-)

Index: longterm-2.6.27/drivers/video/carminefb.c
===================================================================
--- longterm-2.6.27.orig/drivers/video/carminefb.c	2012-02-05 22:34:33.561914997 +0100
+++ longterm-2.6.27/drivers/video/carminefb.c	2012-02-05 22:34:41.662915038 +0100
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
@@ -45,7 +45,7 @@
  * 0b010 Display 1
  */
 static int fb_displays = CARMINE_USE_DISPLAY0 | CARMINE_USE_DISPLAY1;
-module_param(fb_displays, int, 444);
+module_param(fb_displays, int, 0444);
 MODULE_PARM_DESC(fb_displays, "Bit mode, which displays are used");
 
 struct carmine_hw {


