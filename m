Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1APShI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:37:08 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:42078 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1APShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:37:05 -0500
Date: Sun, 16 Jan 2011 19:36:58 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] m68k/amiga: Reclaim Chip RAM for PPC exception handlers
Message-ID: <alpine.DEB.2.00.1101161931280.12726@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k, it doesn't make sense to reserve memory for the PPC exception
handlers, and APUS support is dead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Or does this impact Amigas with APUS boards running in m68k mode?
As we don't (no longer) modify the start address, we were actually stealing the
_last_ 4 pages.

 arch/m68k/amiga/chipram.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index 61df1d3..dd0447d 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -33,10 +33,6 @@ void __init amiga_chip_init(void)
     if (!AMIGAHW_PRESENT(CHIP_RAM))
 	return;
 
-    /*
-     *  Remove the first 4 pages where PPC exception handlers will be located
-     */
-    amiga_chip_size -= 0x4000;
     chipram_res.end = amiga_chip_size-1;
     request_resource(&iomem_resource, &chipram_res);
 
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
