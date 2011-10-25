Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1JYHmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:42:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59031 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1JYHmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <201110250229.p9P2Tvth015729@goober.corp.nai.org>
References: <201110250229.p9P2Tvth015729@goober.corp.nai.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 09:42:02 +0200
X-Google-Sender-Auth: zM-nPk5AK_IzbxoARpwMmR6cWYY
Message-ID: <CA+55aFzLBaLpBWA8tspNbCyzMYeruK-waRCpRwVnZEOGw9FhRQ@mail.gmail.com>
Subject: Re: [git pull] m68knommu arch updates for 3.2
To: Greg Ungerer <gerg@snapgear.com>
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        uclinux-dev@uclinux.org, geert@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Another cut-and-paste reply, please replace "p9" with "m68knommu".
Also note that signed emails aren't convenient (the tools that
actually verify signed emails are unusuable in all other respects), so
an extra signed tag that actually specifies both the top commit and
the repository I'm supposed to pull is likely the best approach if you
don't have access to a trusted host ]

So for the merge window, I *really* want the development trees I pull
from explicitly verified some way.

Now, the p9 patches seem to be small enough, and not core enough, for
me to care deeply, but I really *really* want to not see unsigned
github things.

Putting a signed tag on there somewhere that actually signs the top
commit *and* mentions the repository and branch it is on (ie github)
is not wonderfully convenient, but it's at least relatively
straightforward (do I have a gpg key I can trust?).

Or using a host that I can trust is being maintained by you guys (or
some trusted third party like kernel.org).

(Also, I'm only seeing about half the patches mentioned in linux-next. Hmm?)

Please? Not pulled.

                  Linus

On Tue, Oct 25, 2011 at 4:29 AM, Greg Ungerer <gerg@snapgear.com> wrote:
>
> Hi Linus,
>
> Can you please pull the m68knommu git tree, for-linus branch:
>
>  git@github.com:gregungerer/m68knommu.git for-linus
>
> There is a big cleanup and reworking of the Kconfig files. They are no
> longer splilt on the somewhat arbitary basis of MMU and non-MMU targets.
> Also some other merging and cleaning up of arch Makefiles, and the trap
> handling code. Of course a couple of bug fixes in there too.
>
> Thanks
> Greg
>
>
>
>
> The following changes since commit 899e3ee404961a90b828ad527573aaaac39f0ab1:
>  Linus Torvalds (1):
>        Linux 3.1-rc10
>
> are available in the git repository at:
>
>  git@github.com:gregungerer/m68knommu.git for-linus
>
> Greg Ungerer (11):
>      m68k: fix memcpy to unmatched/unaligned source and dest on 68000
>      m68k: reorganize Kconfig options to improve mmu/non-mmu selections
>      m68k: merge mmu and non-mmu arch Makefiles
>      m68k: merge the mmu and non-mmu kernel/Makefiles
>      m68k: merge mmu and non-mmu include/asm/entry.h files
>      m68k: move hardware vector setting from traps.c to its own file
>      m68k: merge the mmu and non-mmu traps.c files
>      m68knommu: use generic section names in setup code
>      m68knommu: use generic section names in mm/init code
>      m68knommu: remove extern declarations of memory_start/memory_end from mm/init
>      m68knommu: create common externs for _ram* vars
>
> Paul Bolle (2):
>      m68k: drop unused Kconfig symbols
>      m68k: drop unused Kconfig symbols
>
> Peter Turczak (1):
>      m68knommu: fix problems with SPI/GPIO on ColdFire 520x
>
>  arch/m68k/Kconfig                            |  195 +----
>  arch/m68k/Kconfig.bus                        |   55 ++
>  arch/m68k/Kconfig.cpu                        |  429 +++++++++
>  arch/m68k/Kconfig.devices                    |  123 +++
>  arch/m68k/{Kconfig.nommu => Kconfig.machine} |  562 ++++--------
>  arch/m68k/Kconfig.mmu                        |  411 ---------
>  arch/m68k/Makefile                           |  168 ++++-
>  arch/m68k/Makefile_mm                        |  121 ---
>  arch/m68k/Makefile_no                        |  124 ---
>  arch/m68k/include/asm/entry.h                |  255 ++++++-
>  arch/m68k/include/asm/entry_mm.h             |  128 ---
>  arch/m68k/include/asm/entry_no.h             |  181 ----
>  arch/m68k/include/asm/m520xsim.h             |   26 +-
>  arch/m68k/include/asm/mcfqspi.h              |    8 +-
>  arch/m68k/include/asm/page_no.h              |    3 +
>  arch/m68k/include/asm/processor.h            |    6 +
>  arch/m68k/include/asm/sections.h             |    2 +
>  arch/m68k/kernel/Makefile                    |   24 +-
>  arch/m68k/kernel/Makefile_mm                 |   17 -
>  arch/m68k/kernel/Makefile_no                 |   10 -
>  arch/m68k/kernel/entry_no.S                  |    6 +-
>  arch/m68k/kernel/setup_no.c                  |    4 +-
>  arch/m68k/kernel/traps.c                     | 1108 +++++++++++++++++++++++-
>  arch/m68k/kernel/traps_mm.c                  | 1207 --------------------------
>  arch/m68k/kernel/traps_no.c                  |  361 --------
>  arch/m68k/kernel/vectors.c                   |  145 +++
>  arch/m68k/lib/memcpy.c                       |    9 +
>  arch/m68k/mm/init_no.c                       |   21 +-
>  arch/m68k/platform/520x/config.c             |    6 +-
>  arch/m68k/platform/520x/gpio.c               |   50 +-
>  arch/m68k/platform/68328/Makefile            |    5 +-
>  arch/m68k/platform/68328/entry.S             |   18 +-
>  arch/m68k/platform/68360/Makefile            |    6 +-
>  arch/m68k/platform/68360/entry.S             |    4 +-
>  arch/m68k/platform/coldfire/entry.S          |    6 +-
>  35 files changed, 2596 insertions(+), 3208 deletions(-)
>  create mode 100644 arch/m68k/Kconfig.bus
>  create mode 100644 arch/m68k/Kconfig.cpu
>  create mode 100644 arch/m68k/Kconfig.devices
>  rename arch/m68k/{Kconfig.nommu => Kconfig.machine} (58%)
>  delete mode 100644 arch/m68k/Kconfig.mmu
>  delete mode 100644 arch/m68k/Makefile_mm
>  delete mode 100644 arch/m68k/Makefile_no
>  delete mode 100644 arch/m68k/include/asm/entry_mm.h
>  delete mode 100644 arch/m68k/include/asm/entry_no.h
>  delete mode 100644 arch/m68k/kernel/Makefile_mm
>  delete mode 100644 arch/m68k/kernel/Makefile_no
>  delete mode 100644 arch/m68k/kernel/traps_mm.c
>  delete mode 100644 arch/m68k/kernel/traps_no.c
>  create mode 100644 arch/m68k/kernel/vectors.c
>
