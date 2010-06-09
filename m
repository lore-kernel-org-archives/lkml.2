Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0FIJbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:31:35 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:50115 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab0FIJbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:31:33 -0400
Date: Wed, 9 Jun 2010 11:31:31 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] zorro: Fix reading of proc/bus/zorro/* in small chunks
Message-ID: <alpine.DEB.2.00.1006091129240.8858@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_bus_zorro_read() didn't take into account the current file position,
hence it always read from the start of the ConfigDev.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index aaf8abb..108096f 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -73,7 +73,7 @@ proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *
 	cd.cd_BoardAddr = (void *)zorro_resource_start(z);
 	cd.cd_BoardSize = zorro_resource_len(z);
 
-	if (copy_to_user(buf, &cd, nbytes))
+	if (copy_to_user(buf, (void *)&cd + pos, nbytes))
 		return -EFAULT;
 	*ppos += nbytes;
 
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
