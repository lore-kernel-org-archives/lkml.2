Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2DFPY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:24:58 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:55009 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2DFPY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:24:57 -0400
Message-ID: <4F7F0AC5.2050805@tilera.com>
Date: Fri, 6 Apr 2012 11:24:53 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/tile bug fixes for v3.4-rc2
References: <4F7A2503.6070706@tilera.com>
In-Reply-To: <4F7A2503.6070706@tilera.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Ping?  This branch doesn't seem to have been pulled yet.  This is a few
"unbreak the build" changes, plus a bunch of things we've been testing for
a long time internally and are strictly bugfixes.

Thanks!
Chris

On 4/2/2012 6:15 PM, Chris Metcalf wrote:
> Linus,
>
> Please pull the following changes for 3.4-rc2 from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable
>
> This includes Paul Gortmaker's change to fix the <asm/system.h> disintegration
> issues on tile, a fix to unbreak the tilepro ethernet driver, and a backlog
> of bugfix-only changes from internal Tilera development over the last few months.
> They have all been to LKML and on linux-next for the last few days.  The
> EDAC change to MAINTAINERS is an oddity but discussion on the linux-edac list
> suggested I ask you to pull that change through my tree since they don't have
> a tree to pull edac changes from at the moment.
>
> Chris Metcalf (38):
>       arch/tile/Kconfig: remove pointless "!M386" test.
>       arch/tile/Kconfig: rename tile_defconfig to tilepro_defconfig
>       arch/tile/Kconfig: don't specify CONFIG_PAGE_OFFSET for 64-bit builds
>       arch/tile: fix typo in <arch/spr_def.h>
>       arch/tile: revert comment for atomic64_add_unless().
>       arch/tile: fix gcc 4.6 warnings in <asm/bitops_64.h>
>       arch/tile: use 0 for IRQ_RESCHEDULE instead of 1
>       arch/tile: avoid false corrupt frame warning in early boot
>       arch/tile: make sure to build memcpy_user_64 without frame pointer
>       arch/tile: various bugs in stack backtracer
>       arch/tile: work around a hardware issue with the return-address stack
>       arch/tile: fix up some minor trap handling issues
>       arch/tile: fix a couple of comments that needed updating
>       arch/tile/Makefile: use KCFLAGS when figuring out the libgcc path.
>       arch/tile: don't wait for migrating PTEs in an NMI handler
>       arch/tile: don't set the homecache of a PTE unless appropriate
>       arch/tile: don't enable irqs unconditionally in page fault handler
>       arch/tile: fix bug in loading kernels larger than 16 MB
>       arch/tile: fix bug in delay_backoff()
>       arch/tile: don't leak kernel memory when we unload modules
>       arch/tile: fix up locking in pgtable.c slightly
>       arch/tile: use proper memparse() for "maxmem" options
>       arch/tile: add "nop" after "nap" to help GX idle power draw
>       arch/tile: implement panic_smp_self_stop()
>       arch/tile: fix single-stepping over swint1 instructions on tilegx
>       arch/tile: fix pointer cast in cacheflush.c
>       arch/tile: export the page_home() function.
>       arch/tile: stop mentioning the "kvm" subdirectory
>       arch/tile: use atomic exchange in arch_write_unlock()
>       arch/tile: fix finv_buffer_remote() for tilegx
>       arch/tile: return SIGBUS for addresses that are unaligned AND invalid
>       arch/tile: remove bogus performance optimization
>       arch/tile: avoid accidentally unmasking NMI-type interrupt accidentally
>       edac: say "TILEGx" not "TILEPro" for the tilegx edac driver
>       tile-srom.c driver: minor code cleanup
>       tilepro ethernet driver: fix a few minor issues
>       MAINTAINERS: update EDAC information
>       drivers/net/ethernet/tile: fix netdev_alloc_skb() bombing
>
> Paul Gortmaker (1):
>       tile: fix multiple build failures from system.h dismantle
>
>  MAINTAINERS                         |   22 ++--
>  arch/tile/Kconfig                   |    8 +-
>  arch/tile/Makefile                  |    5 +-
>  arch/tile/include/arch/spr_def.h    |    4 +-
>  arch/tile/include/asm/atomic.h      |   50 +-------
>  arch/tile/include/asm/atomic_32.h   |    2 +-
>  arch/tile/include/asm/bitops_64.h   |    8 +-
>  arch/tile/include/asm/cmpxchg.h     |   73 +++++++++++
>  arch/tile/include/asm/irq.h         |    2 +-
>  arch/tile/include/asm/spinlock_64.h |    2 +-
>  arch/tile/include/asm/stack.h       |    1 -
>  arch/tile/include/asm/traps.h       |    6 +-
>  arch/tile/kernel/entry.S            |    2 +
>  arch/tile/kernel/intvec_32.S        |   24 +++-
>  arch/tile/kernel/intvec_64.S        |   52 +++++++-
>  arch/tile/kernel/module.c           |    2 +
>  arch/tile/kernel/process.c          |    3 +-
>  arch/tile/kernel/setup.c            |   28 +++--
>  arch/tile/kernel/single_step.c      |   31 +++--
>  arch/tile/kernel/smp.c              |    8 +-
>  arch/tile/kernel/stack.c            |  232 +++++++++++++++++------------------
>  arch/tile/kernel/traps.c            |   15 ++-
>  arch/tile/lib/Makefile              |    1 +
>  arch/tile/lib/cacheflush.c          |   30 ++++-
>  arch/tile/lib/memcpy_user_64.c      |    8 +-
>  arch/tile/lib/spinlock_common.h     |    2 +-
>  arch/tile/mm/fault.c                |   22 +++-
>  arch/tile/mm/homecache.c            |    1 +
>  arch/tile/mm/init.c                 |   26 +++--
>  arch/tile/mm/pgtable.c              |   38 ++++--
>  drivers/char/tile-srom.c            |   12 +-
>  drivers/edac/tile_edac.c            |    4 +
>  drivers/net/ethernet/tile/tilepro.c |   77 ++++++++----
>  33 files changed, 501 insertions(+), 300 deletions(-)
>  create mode 100644 arch/tile/include/asm/cmpxchg.h
>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

