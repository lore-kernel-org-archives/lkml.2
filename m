Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655Ab1JYORh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:17:37 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:65385 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933642Ab1JYORe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:17:34 -0400
Message-ID: <4EA6C488.1030606@snapgear.com>
Date: Wed, 26 Oct 2011 00:15:36 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: Re: [git pull] m68knommu arch updates for 3.2
References: <201110250229.p9P2Tvth015729@goober.corp.nai.org> <CA+55aFzLBaLpBWA8tspNbCyzMYeruK-waRCpRwVnZEOGw9FhRQ@mail.gmail.com>
In-Reply-To: <CA+55aFzLBaLpBWA8tspNbCyzMYeruK-waRCpRwVnZEOGw9FhRQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 10/25/2011 05:42 PM, Linus Torvalds wrote:
> [ Another cut-and-paste reply, please replace "p9" with "m68knommu".
> Also note that signed emails aren't convenient (the tools that
> actually verify signed emails are unusuable in all other respects), so
> an extra signed tag that actually specifies both the top commit and
> the repository I'm supposed to pull is likely the best approach if you
> don't have access to a trusted host ]

I don't think I will get back onto kernel.org anytime soon, I am in
the "geographically-isolated developers" group :-(

But I have put a signed tag on the top commit now, with the top
commit and repository info. Is this what you are looking for?

So it was:

    git://github.com/gregungerer/m68knommu for-linus

with new for-linus top tag:

    m68knommu-for-linus-3.2-merge-window

and pull comments:

There is a big cleanup and reworking of the Kconfig files. They are no
longer splilt on the somewhat arbitary basis of MMU and non-MMU targets.
Also some other merging and cleaning up of arch Makefiles, and the trap
handling code. Of course a couple of bug fixes in there too.

Thanks
Greg




The following changes since commit 899e3ee404961a90b828ad527573aaaac39f0ab1:
   Linus Torvalds (1):
         Linux 3.1-rc10

are available in the git repository at:

   git://github.com/gregungerer/m68knommu for-linus

Greg Ungerer (11):
       m68k: fix memcpy to unmatched/unaligned source and dest on 68000
       m68k: reorganize Kconfig options to improve mmu/non-mmu selections
       m68k: merge mmu and non-mmu arch Makefiles
       m68k: merge the mmu and non-mmu kernel/Makefiles
       m68k: merge mmu and non-mmu include/asm/entry.h files
       m68k: move hardware vector setting from traps.c to its own file
       m68k: merge the mmu and non-mmu traps.c files
       m68knommu: use generic section names in setup code
       m68knommu: use generic section names in mm/init code
       m68knommu: remove extern declarations of memory_start/memory_end 
from mm/init
       m68knommu: create common externs for _ram* vars

Paul Bolle (2):
       m68k: drop unused Kconfig symbols
       m68k: drop unused Kconfig symbols

Peter Turczak (1):
       m68knommu: fix problems with SPI/GPIO on ColdFire 520x

  arch/m68k/Kconfig                            |  195 +----
  arch/m68k/Kconfig.bus                        |   55 ++
  arch/m68k/Kconfig.cpu                        |  429 +++++++++
  arch/m68k/Kconfig.devices                    |  123 +++
  arch/m68k/{Kconfig.nommu => Kconfig.machine} |  562 ++++--------
  arch/m68k/Kconfig.mmu                        |  411 ---------
  arch/m68k/Makefile                           |  168 ++++-
  arch/m68k/Makefile_mm                        |  121 ---
  arch/m68k/Makefile_no                        |  124 ---
  arch/m68k/include/asm/entry.h                |  255 ++++++-
  arch/m68k/include/asm/entry_mm.h             |  128 ---
  arch/m68k/include/asm/entry_no.h             |  181 ----
  arch/m68k/include/asm/m520xsim.h             |   26 +-
  arch/m68k/include/asm/mcfqspi.h              |    8 +-
  arch/m68k/include/asm/page_no.h              |    3 +
  arch/m68k/include/asm/processor.h            |    6 +
  arch/m68k/include/asm/sections.h             |    2 +
  arch/m68k/kernel/Makefile                    |   24 +-
  arch/m68k/kernel/Makefile_mm                 |   17 -
  arch/m68k/kernel/Makefile_no                 |   10 -
  arch/m68k/kernel/entry_no.S                  |    6 +-
  arch/m68k/kernel/setup_no.c                  |    4 +-
  arch/m68k/kernel/traps.c                     | 1108 
+++++++++++++++++++++++-
  arch/m68k/kernel/traps_mm.c                  | 1207 
--------------------------
  arch/m68k/kernel/traps_no.c                  |  361 --------
  arch/m68k/kernel/vectors.c                   |  145 +++
  arch/m68k/lib/memcpy.c                       |    9 +
  arch/m68k/mm/init_no.c                       |   21 +-
  arch/m68k/platform/520x/config.c             |    6 +-
  arch/m68k/platform/520x/gpio.c               |   50 +-
  arch/m68k/platform/68328/Makefile            |    5 +-
  arch/m68k/platform/68328/entry.S             |   18 +-
  arch/m68k/platform/68360/Makefile            |    6 +-
  arch/m68k/platform/68360/entry.S             |    4 +-
  arch/m68k/platform/coldfire/entry.S          |    6 +-
  35 files changed, 2596 insertions(+), 3208 deletions(-)
  create mode 100644 arch/m68k/Kconfig.bus
  create mode 100644 arch/m68k/Kconfig.cpu
  create mode 100644 arch/m68k/Kconfig.devices
  rename arch/m68k/{Kconfig.nommu => Kconfig.machine} (58%)
  delete mode 100644 arch/m68k/Kconfig.mmu
  delete mode 100644 arch/m68k/Makefile_mm
  delete mode 100644 arch/m68k/Makefile_no
  delete mode 100644 arch/m68k/include/asm/entry_mm.h
  delete mode 100644 arch/m68k/include/asm/entry_no.h
  delete mode 100644 arch/m68k/kernel/Makefile_mm
  delete mode 100644 arch/m68k/kernel/Makefile_no
  delete mode 100644 arch/m68k/kernel/traps_mm.c
  delete mode 100644 arch/m68k/kernel/traps_no.c
  create mode 100644 arch/m68k/kernel/vectors.c
