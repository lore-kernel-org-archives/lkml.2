Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0LLXrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36504 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0LLXro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, sam@zoy.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [159/223] USB: misc: trancevibrator: fix up a sysfs attribute permission
Message-Id: <20101212234742.F3988B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit d489a4b3926bad571d404ca6508f6744b9602776 upstream.

It should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Hocevar <sam@zoy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/misc/trancevibrator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/usb/misc/trancevibrator.c
===================================================================
--- linux.orig/drivers/usb/misc/trancevibrator.c
+++ linux/drivers/usb/misc/trancevibrator.c
@@ -86,7 +86,7 @@ static ssize_t set_speed(struct device *
 	return count;
 }
 
-static DEVICE_ATTR(speed, S_IWUGO | S_IRUGO, show_speed, set_speed);
+static DEVICE_ATTR(speed, S_IRUGO | S_IWUSR, show_speed, set_speed);
 
 static int tv_probe(struct usb_interface *interface,
 		    const struct usb_device_id *id)
