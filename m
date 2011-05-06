Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab1EFTIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:08:50 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57247 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab1EFTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:08:48 -0400
Date: Fri, 6 May 2011 21:08:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
cc: Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: Really wire up sys_pselect6 and sys_ppoll
Message-ID: <alpine.DEB.2.00.1105062107290.23969@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We reserved the numbers a long time ago, but never wired them up in the
syscall table as they need TIF_RESTORE_SIGMASK, which we only got last year
in commit cb6831d5d3099e772a510eb3e1ed0760ccffb45e ("m68k: Switch to saner
sigsuspend()")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
I'll move this before "m68k: unistd - Comment out definitions for unimplemented
syscalls", and will update the latter.

 arch/m68k/kernel/syscalltable.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index cb3bc1b..6f7b091 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -321,8 +321,8 @@ ENTRY(sys_call_table)
 	.long sys_readlinkat
 	.long sys_fchmodat
 	.long sys_faccessat		/* 300 */
-	.long sys_ni_syscall		/* Reserved for pselect6 */
-	.long sys_ni_syscall		/* Reserved for ppoll */
+	.long sys_pselect6
+	.long sys_ppoll
 	.long sys_unshare
 	.long sys_set_robust_list
 	.long sys_get_robust_list	/* 305 */
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
