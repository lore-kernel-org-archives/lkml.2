Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0JBGgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 02:36:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39510 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0JBGgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 02:36:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WcuCV2HulJsjTo4yM13lJqD9xkFzIhGxr8jtdtkL0TlQMdibd05m/Z1JXT7HjwuFt4
         eXzYMHeU33KZEtCRInMOoqQln5AoiSC1zFjnkq3Whg+Y1Zdqjmc4rfICUxlDZxajhwM4
         DpbJ1Fxvudt5OHmNhOHjJ5sDhGyUut9H08fyU=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ming Lei <tom.leiming@gmail.com>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Mike Frysinger <vapier@gentoo.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: musb: musb_gadget: Fix error path
Date: Sat,  2 Oct 2010 12:05:48 +0530
Message-Id: <1286001348-3645-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function musb_gadget_setup()
call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/musb/musb_gadget.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index d065e23..9fdd852 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1676,8 +1676,10 @@ int __init musb_gadget_setup(struct musb *musb)
 	musb_platform_try_idle(musb, 0);
 
 	status = device_register(&musb->g.dev);
-	if (status != 0)
+	if (status != 0) {
+		put_device(&musb->g.dev);
 		the_gadget = NULL;
+	}
 	return status;
 }
 
-- 
1.7.2.3

