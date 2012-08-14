Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2HNIXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:23:17 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:39855 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2HNIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:23:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] TTY: synclink_cs, fix build
Date: Tue, 14 Aug 2012 10:23:08 +0200
Message-Id: <1344932588-5529-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120814002304.GA5604@localhost>
References: <20120814002304.GA5604@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "TTY: synclink_cs, use dynamic tty devices" added a call to
tty_port_register_device with a proper device as the last argument.
But it was not correct and it causes build failures:
synclink_cs.c: In function ‘mgslpc_add_device’:
synclink_cs.c:2735:16: error: request for member ‘dev’ in something not a structure or union

info->p_dev is a pointer, so act as that.

I wonder why my build scripts did not notice. I have to re-check them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/char/pcmcia/synclink_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 923c3a4..d9335ae 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2732,7 +2732,7 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 	hdlcdev_init(info);
 #endif
 	tty_port_register_device(&info->port, serial_driver, info->line,
-			&info->p_dev.dev);
+			&info->p_dev->dev);
 }
 
 static void mgslpc_remove_device(MGSLPC_INFO *remove_info)
-- 
1.7.10.4


