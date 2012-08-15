Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2HOUPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:15:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:36937 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab2HOTvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jean Delvare <jdelvare@suse.de>, Paul Mundt <lethal@linux-sh.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 092/165] carminefb: Fix module parameters permissions
Date: Wed, 15 Aug 2012 15:47:16 -0400
Message-ID: <1345060109-9187-93-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/carminefb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/carminefb.c b/drivers/video/carminefb.c
index d8345fc..96b52a4 100644
--- a/drivers/video/carminefb.c
+++ b/drivers/video/carminefb.c
@@ -32,11 +32,11 @@
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
@@ -46,7 +46,7 @@ MODULE_PARM_DESC(fb_mode_str, "Initial video mode in characters.");
  * 0b010 Display 1
  */
 static int fb_displays = CARMINE_USE_DISPLAY0 | CARMINE_USE_DISPLAY1;
-module_param(fb_displays, int, 444);
+module_param(fb_displays, int, 0444);
 MODULE_PARM_DESC(fb_displays, "Bit mode, which displays are used");
 
 struct carmine_hw {
-- 
1.7.12.rc2

