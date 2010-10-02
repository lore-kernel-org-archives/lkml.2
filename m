Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0JBHKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 03:10:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35866 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab0JBHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 03:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Dc+asYdSD/Hnhm4BzplYnN8fqEfbOt1TPJltGHm/0T3iwLt4pyJ93OkTDeAa95+cF9
         XW+elIEXgwj08bYPU9GNgAxE4uMeizFNzTSkVf5Xmj1W3GeDNaRU/90ufyUyEyrnYwQH
         3a/Dx3yenhlj8iN3WamNExGj7VE+8oV8zJJsA=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: amd5536udc: Fix error path
Date: Sat,  2 Oct 2010 12:40:20 +0530
Message-Id: <1286003420-3774-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function udc_probe()
call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/amd5536udc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 731150d4..950ee33 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3382,8 +3382,10 @@ static int udc_probe(struct udc *dev)
 	udc = dev;
 
 	retval = device_register(&dev->gadget.dev);
-	if (retval)
+	if (retval) {
+		put_device(&dev->gadget.dev);
 		goto finished;
+	}
 
 	/* timer init */
 	init_timer(&udc_timer);
-- 
1.7.2.3

