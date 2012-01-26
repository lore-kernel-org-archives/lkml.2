Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2AZRjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:39:36 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:52457 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2AZRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:39:35 -0500
Date: Thu, 26 Jan 2012 18:39:29 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gerg@snapgear.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.3
Message-ID: <alpine.DEB.2.00.1201261828070.19382@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 3bd9e50b4297b0d85bb86a8f2ade941c0f9c21fd:
  Geert Uytterhoeven (1):
        m68k/mac: Make CONFIG_HEARTBEAT unavailable on Mac

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

  - The changeset from Andreas is a critical bugfix (also meant for stable)
    that caused crashes on boot in the wild.
    As it wasn't rebased, it will cause a merge conflict. The correct
    resolution is:

-<<<<<<< HEAD
-               asm volatile ("frestore %0@" : : "a" (&zero) : "memory");
-=======
-               asm volatile (".chip 68k/68881\n\t"
-                             "frestore %0\n\t"
-                             ".chip 68k" : : "m" (zero));
->>>>>>> m68k/for-next = for-linus
+               asm volatile ("frestore %0" : : "m" (zero)

  - The changesets from Finn are fixes for Mac that got silently ignored by
    the respective subsystem maintainers, despite resends.

  - The changeset from me is a postponed cleanup that depended on some
    subsystem trees.

Thanks for pulling!

Andreas Schwab (1):
      m68k: Fix assembler constraint to prevent overeager gcc optimisation

Finn Thain (3):
      macfb: fix black and white modes
      mac_scsi: dont enable mac_scsi irq before requesting it
      mac_esp: rename irq

Geert Uytterhoeven (1):
      m68k/irq: Remove obsolete IRQ_FLG_* definitions

 arch/m68k/atari/config.c      |    8 +++---
 arch/m68k/include/asm/irq.h   |   13 ---------
 arch/m68k/kernel/process_mm.c |    4 +-
 arch/m68k/kernel/process_no.c |    4 +-
 arch/m68k/kernel/traps.c      |   36 +++++++++++-------------
 arch/m68k/mm/cache.c          |    6 ++--
 drivers/scsi/mac_esp.c        |    3 +-
 drivers/scsi/mac_scsi.c       |    6 ----
 drivers/video/macfb.c         |   60 +++++++++++++++++++----------------------
 9 files changed, 57 insertions(+), 83 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
