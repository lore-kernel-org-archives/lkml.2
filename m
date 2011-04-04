Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1DDKbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:31:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60914 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab1DDKbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E/WcrB45hVw5BvMxWMBYWb/yOewO2KWq7axqsCkCtWpF5Sko44NT13gcFEbm74Hb5t
         3R6PBDZRpteTz8wLPxZ7FWEptlO1zik+e7pdoVhXZeK4p+KmsvIGZUCPFsF1TOxJQJ92
         sNDMXT/5GFS7UtawXAl8t/RUjol2WDEp8aqoU=
From: wanlong.gao@gmail.com
To: gregkh@suse.de, jhovold@gmail.com, alan@linux.intel.com, tsozik@yahoo.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiaweiwei.xiyou@gmail.com, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] USB:Fix the wrong function prototype .
Date: Mon,  4 Apr 2011 18:29:57 +0800
Message-Id: <1301912997-21248-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

While the "mct_u232_device.ioctl" initialized by a wrong function
prototype . And the argument "struct file *file" is unused in
the function "mct_u232_ioctl()".

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/usb/serial/mct_u232.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index d2c0196..ba0d287
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -106,7 +106,7 @@ static void mct_u232_break_ctl(struct tty_struct *tty, int break_state);
 static int  mct_u232_tiocmget(struct tty_struct *tty);
 static int  mct_u232_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
-static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+static int  mct_u232_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static int  mct_u232_get_icount(struct tty_struct *tty,
 			struct serial_icounter_struct *icount);
@@ -874,7 +874,7 @@ static void mct_u232_unthrottle(struct tty_struct *tty)
 	}
 }
 
-static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+static int  mct_u232_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	DEFINE_WAIT(wait);
-- 
1.7.3

