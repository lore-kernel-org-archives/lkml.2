Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab0HLARY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:17:24 -0400
Received: from kroah.org ([198.145.64.141]:60525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab0HLAIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:15 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:14 2010
Message-Id: <20100812000614.686010480@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Huewe <peterhuewe@gmx.de>,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [22/67] drivers/video/w100fb.c: ignore void return value / fix build failure
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Huewe <peterhuewe@gmx.de>

commit fa260c00c1aa5c657793a7221e40d2400df5afd8 upstream.

Fix a build failure "error: void value not ignored as it ought to be"
by removing an assignment of a void return value.  The functionality of
the code is not changed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/w100fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -858,9 +858,9 @@ unsigned long w100fb_gpio_read(int port)
 void w100fb_gpio_write(int port, unsigned long value)
 {
 	if (port==W100_GPIO_PORT_A)
-		value = writel(value, remapped_regs + mmGPIO_DATA);
+		writel(value, remapped_regs + mmGPIO_DATA);
 	else
-		value = writel(value, remapped_regs + mmGPIO_DATA2);
+		writel(value, remapped_regs + mmGPIO_DATA2);
 }
 EXPORT_SYMBOL(w100fb_gpio_read);
 EXPORT_SYMBOL(w100fb_gpio_write);


