Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab1KIThp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:37:45 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:56061 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1KIThn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:37:43 -0500
Date: Wed, 9 Nov 2011 20:37:37 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.2
Message-ID: <alpine.DEB.2.00.1111092029470.11859@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

	Hi Linus,

As promised, here's the second pull request for the m68k changes for 3.2:
  - The biggest chunk is the long-overdue conversion of m68k to the generic
    hardirq framework.
    (the IDE change was acked by Thomas Gleixner and Borislav Petkov)
  - Two commits fix the loss of two sets of config options during the
    m68k/m68knommu Kconfig merge.

Thanks for pulling!

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:
  Linus Torvalds (1):
        Linux 3.2-rc1

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Finn Thain (1):
      m68k/mac: Remove mac_irq_{en,dis}able() wrappers

Geert Uytterhoeven (28):
      m68k: Revive lost ARAnyM config options
      m68k: Revive lost DIO bus config option
      ide-{cd,floppy,tape}: Do not include <linux/irq.h>
      m68k/irq: Rename irq_controller to irq_chip
      m68k/irq: Kill irq_node_t typedef, always use struct irq_node
      m68k/irq: Rename irq_node to irq_data
      m68k/irq: Switch irq_chip methods to "struct irq_data *data"
      m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
      m68k/irq: Extract irq_set_chip()
      m68k/irq: Add m68k_setup_irq_controller()
      m68k/irq: Rename {,__}m68k_handle_int()
      m68k/irq: Remove obsolete IRQ_FLG_* users
      m68k/irq: Add genirq support
      m68k/atari: Convert Atari to genirq
      m68k/atari: Remove code and comments about different irq types
      m68k/amiga: Refactor amiints.c
      m68k/amiga: Convert Amiga to genirq
      m68k/amiga: Optimize interrupts using chain handlers
      m68k/mac: Convert Mac to genirq
      m68k/mac: Optimize interrupts using chain handlers
      m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
      m68k/vme: Convert VME to genirq
      m68k/apollo: Convert Apollo to genirq
      m68k/sun3: Use the kstat_irqs_cpu() wrapper
      m68k/sun3: Convert Sun3/3x to genirq
      m68k/q40: Convert Q40/Q60 to genirq
      m68k/irq: Remove obsolete m68k irq framework
      m68k/irq: Remove obsolete support for user vector interrupt fixups

 arch/m68k/Kconfig                 |    4 +-
 arch/m68k/Kconfig.bus             |    9 +
 arch/m68k/Kconfig.devices         |   31 ++++
 arch/m68k/amiga/amiints.c         |  168 ++++++++------------
 arch/m68k/amiga/cia.c             |   39 +++--
 arch/m68k/apollo/dn_ints.c        |   35 +++--
 arch/m68k/atari/ataints.c         |  274 +++----------------------------
 arch/m68k/bvme6000/config.c       |    2 +-
 arch/m68k/hp300/time.c            |    2 +-
 arch/m68k/include/asm/hardirq.h   |    5 +
 arch/m68k/include/asm/irq.h       |   69 ++------
 arch/m68k/include/asm/macintosh.h |    2 +
 arch/m68k/include/asm/q40ints.h   |    3 -
 arch/m68k/kernel/Makefile         |    9 +-
 arch/m68k/kernel/entry_mm.S       |    7 +-
 arch/m68k/kernel/ints.c           |  323 ++++---------------------------------
 arch/m68k/mac/baboon.c            |   21 +--
 arch/m68k/mac/iop.c               |   10 +-
 arch/m68k/mac/macints.c           |   24 ++--
 arch/m68k/mac/oss.c               |   54 +++----
 arch/m68k/mac/psc.c               |   49 +++---
 arch/m68k/mac/via.c               |   74 ++++-----
 arch/m68k/mvme147/config.c        |    5 +-
 arch/m68k/mvme16x/config.c        |    2 +-
 arch/m68k/q40/q40ints.c           |   60 ++++----
 arch/m68k/sun3/sun3ints.c         |   46 +++---
 drivers/ide/ide-cd.c              |    1 -
 drivers/ide/ide-floppy.c          |    1 -
 drivers/ide/ide-tape.c            |    1 -
 drivers/macintosh/via-macii.c     |    2 +-
 drivers/macintosh/via-maciisi.c   |    4 +-
 31 files changed, 393 insertions(+), 943 deletions(-)

Gr{oetje,eeting}s,

						Geert

- --
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOutQiAAoJEEgEtLw/Ve77oMAQAIbEvC/Cij8N17TTBKiRZUnQ
mWVNI/upH6TlSd1b9V/sPX29/mHkrcp05Kv5tzH7iEl1BimPRhIxuQEcGAHOLpVm
tlKB1Kr78BndiWgjf0+BLrDmQ0eklFfeTlH9cZkIm4pYr9NlbKNbPYMBDMjcq0dA
mo4EVzYpbTkGyVp4IYwI3zySkUK1BrgVr317spjMu0Tm1rqcOylaIdNf9RMtWp37
ChhLhRBHwy1kV4ZVRongh86a6C5BFC/Olpu5MBn6VPAN72J1h1/lNyyvRN+x4huL
OVNpCiKZs2iHP8j5YMEWbUcxE1yLCYsUvGZ+5b/aZFFfPSu0etlMUZJ8aUAokTN9
YgykAtjAuN5OGbEx/8Pz3zOZMTtSE+x9/XYv9QVi3+9JTXgtncZHPc0SoTnuVqw2
NLIc6JdV/b/6KpNdGt4GlZ+yWWebXNm8/7+4INww1J+OEtiDa2OrWROPyWOImAav
K0KeFEog6Nkp4wcj5upP6kjeuHfDEn8UIpjfLp8hAzTd9QA+XCYKbxDk5uM+OyVe
WbsKlCd9xtxekke8sDcpO0n+9EEcQMwJLdKuyVy2hel3y9eHOQRR3OA0B6GqYbRm
uvlZrJPu5/tcLDcNZBPEWAN23mivasY+5PUpXVl9L+k2oGIpTjhH+Us61PFzXpg5
+wQ8Nza5WaUypNWhEOuR
=WSLh
-----END PGP SIGNATURE-----
