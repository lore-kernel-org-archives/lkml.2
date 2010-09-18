Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0IRTvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:51:54 -0400
Received: from kroah.org ([198.145.64.141]:51418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab0IRTBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:45 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:57 2010
Message-Id: <20100918185957.441942755@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [054/123] Input: i8042 - fix device removal on unload
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=input-i8042-fix-device-removal-on-unload.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
@@ -1412,8 +1412,8 @@ static int __init i8042_init(void)
 
 static void __exit i8042_exit(void)
 {
-	platform_driver_unregister(&i8042_driver);
 	platform_device_unregister(i8042_platform_device);
+	platform_driver_unregister(&i8042_driver);
 	i8042_platform_exit();
 
 	panic_blink = NULL;


