Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1EDO3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:29:36 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:46649 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1EDO3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:29:35 -0400
Date: Wed, 4 May 2011 16:29:31 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc/mpc8610_hpcd: Do not use "/" in interrupt names
Message-ID: <alpine.DEB.2.00.1105041627560.2601@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It may trigger a warning in fs/proc/generic.c:__xlate_proc_name() when
trying to add an entry for the interrupt handler to sysfs.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index 018cc67..efadd3b 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -66,7 +66,7 @@ static void __init mpc8610_suspend_init(void)
 		return;
 	}
 
-	ret = request_irq(irq, mpc8610_sw9_irq, 0, "sw9/wakeup", NULL);
+	ret = request_irq(irq, mpc8610_sw9_irq, 0, "sw9:wakeup", NULL);
 	if (ret) {
 		pr_err("%s: can't request pixis event IRQ: %d\n",
 		       __func__, ret);
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
