Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0LHAjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:39:00 -0500
Received: from kroah.org ([198.145.64.141]:54811 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab0LHAeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:36 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:06:42 2010
Message-Id: <20101208000641.937942615@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:04:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sam Hocevar <sam@zoy.org>
Subject: [24/44] USB: misc: trancevibrator: fix up a sysfs attribute permission
In-Reply-To: <20101208003205.GA4286@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit d489a4b3926bad571d404ca6508f6744b9602776 upstream.

It should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Hocevar <sam@zoy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/trancevibrator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/trancevibrator.c
+++ b/drivers/usb/misc/trancevibrator.c
@@ -85,7 +85,7 @@ static ssize_t set_speed(struct device *
 	return count;
 }
 
-static DEVICE_ATTR(speed, S_IWUGO | S_IRUGO, show_speed, set_speed);
+static DEVICE_ATTR(speed, S_IRUGO | S_IWUSR, show_speed, set_speed);
 
 static int tv_probe(struct usb_interface *interface,
 		    const struct usb_device_id *id)


