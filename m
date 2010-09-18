Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab0IRTP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:58 -0400
Received: from kroah.org ([198.145.64.141]:43717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080Ab0IRTP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:56 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:05 2010
Message-Id: <20100918191305.060440464@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [090/129] Input: i8042 - fix device removal on unload
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit af045b86662f17bf130239a65995c61a34f00a6b upstream.

We need to call platform_device_unregister(i8042_platform_device)
before calling platform_driver_unregister() because i8042_remove()
resets i8042_platform_device to NULL. This leaves the platform device
instance behind and prevents driver reload.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=16613

Reported-by: Seryodkin Victor <vvscore@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1483,8 +1483,8 @@ static int __init i8042_init(void)
 
 static void __exit i8042_exit(void)
 {
-	platform_driver_unregister(&i8042_driver);
 	platform_device_unregister(i8042_platform_device);
+	platform_driver_unregister(&i8042_driver);
 	i8042_platform_exit();
 
 	panic_blink = NULL;


