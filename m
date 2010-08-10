Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab0HJTT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:19:57 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:48079 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab0HJTTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:19:52 -0400
Date: Tue, 10 Aug 2010 21:19:50 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: spectra needs <linux/slab.h>
Message-ID: <alpine.DEB.2.00.1008102119170.20140@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one of my m68k test builds I get:

drivers/staging/spectra/ffsport.c: In function ¡ioctl_read_page_data¢:
drivers/staging/spectra/ffsport.c:196: error: implicit declaration of function ¡kmalloc¢
drivers/staging/spectra/ffsport.c:196: warning: assignment makes pointer from integer without a cast
drivers/staging/spectra/ffsport.c:212: error: implicit declaration of function ¡kfree¢
drivers/staging/spectra/ffsport.c: In function ¡ioctl_write_page_data¢:
drivers/staging/spectra/ffsport.c:229: warning: assignment makes pointer from integer without a cast
drivers/staging/spectra/ffsport.c: In function ¡SBD_setup_device¢:
drivers/staging/spectra/ffsport.c:633: warning: assignment makes pointer from integer without a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/spectra/ffsport.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/spectra/ffsport.c b/drivers/staging/spectra/ffsport.c
index d0c5c97..a8ff80c 100644
--- a/drivers/staging/spectra/ffsport.c
+++ b/drivers/staging/spectra/ffsport.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/log2.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 
 /**** Helper functions used for Div, Remainder operation on u64 ****/
 
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
