Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0KDPlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:41:20 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:32548 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0KDPlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:41:18 -0400
Message-ID: <4CD2D41A.8060007@tilera.com>
Date: Thu, 4 Nov 2010 11:41:14 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile bugfixes for v2.6.37
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Can you please pull for 2.6.37 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These changes are all build- or bug-fixes.  The <asm-generic/stat.h> change
is an ABI fix for our 64-bit tilegx hardware, which is building off these
sources internally but for which we haven't yet released all the pieces.
It does not affect any other platform, since the other arch's using this header
are all 32-bit and the change is just "int" vs "long" in "struct stat".

Chris Metcalf (7):
      arch/tile: complete migration to new kmap_atomic scheme
      arch/tile: bomb raw_local_irq_ to arch_local_irq_
      arch/tile: avoid __must_check warning on one strict_strtol check
      arch/tile: correct double syscall restart for nested signals
      arch/tile: don't allow user code to set the PL via ptrace or signal return
      asm-generic/stat.h: support 64-bit file time_t for stat()
      arch/tile: mark "hardwall" device as non-seekable

 arch/tile/include/asm/highmem.h    |    1 -
 arch/tile/include/asm/kmap_types.h |   34 ++++++++++++++++++++++---------
 arch/tile/include/asm/pgtable.h    |    6 +---
 arch/tile/include/asm/stat.h       |    3 ++
 arch/tile/include/asm/unistd.h     |    1 +
 arch/tile/kernel/compat.c          |   10 ++++----
 arch/tile/kernel/early_printk.c    |    2 +-
 arch/tile/kernel/hardwall.c        |    6 ++--
 arch/tile/kernel/irq.c             |    4 +-
 arch/tile/kernel/machine_kexec.c   |    6 ++--
 arch/tile/kernel/messaging.c       |    2 +-
 arch/tile/kernel/ptrace.c          |   39 +++++++++++++++++++----------------
 arch/tile/kernel/reboot.c          |    6 ++--
 arch/tile/kernel/setup.c           |    8 +++---
 arch/tile/kernel/signal.c          |    9 +++++++-
 arch/tile/kernel/smp.c             |    2 +-
 arch/tile/kernel/time.c            |    8 +++---
 arch/tile/lib/memcpy_tile64.c      |   11 +++++++--
 arch/tile/mm/highmem.c             |    2 +-
 arch/tile/mm/init.c                |    8 +++++-
 arch/tile/mm/pgtable.c             |    4 +-
 include/asm-generic/stat.h         |   14 ++++++------
 22 files changed, 110 insertions(+), 76 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

