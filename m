Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758Ab0HEWsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:48:39 -0400
Received: from kroah.org ([198.145.64.141]:37542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759422Ab0HEWXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Egger <siccegge@cs.fau.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/67] serial: There's no config CONSOLE
Date: Thu,  5 Aug 2010 15:22:29 -0700
Message-Id: <1281047014-23429-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>

as there's no config CONSOLE (never has been as far as I can tell) and
noone has ever missed that piece of code, it should be safe to remove
it making the kernel a tiny bit less complex.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/68328serial.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 3046386..9330edb 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -78,10 +78,6 @@ struct m68k_serial *m68k_consinfo = 0;
 
 #define M68K_CLOCK (16667000) /* FIXME: 16MHz is likely wrong */
 
-#ifdef CONFIG_CONSOLE
-extern wait_queue_head_t keypress_wait; 
-#endif
-
 struct tty_driver *serial_driver;
 
 /* number of characters left in xmit buffer before we ask for more */
@@ -300,10 +296,6 @@ static void receive_chars(struct m68k_serial *info, unsigned short rx)
 				return;
 #endif /* CONFIG_MAGIC_SYSRQ */
 			}
-			/* It is a 'keyboard interrupt' ;-) */
-#ifdef CONFIG_CONSOLE
-			wake_up(&keypress_wait);
-#endif			
 		}
 
 		if(!tty)
-- 
1.7.2

