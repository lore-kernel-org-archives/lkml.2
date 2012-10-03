Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2JCGOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:14:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54262 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2JCGOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:14:05 -0400
Date: Wed, 03 Oct 2012 02:14:04 -0400 (EDT)
Message-Id: <20121003.021404.571541314643591174.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some quick fixes after today's merge-window pull.

1) Add missing dependency on Sparc DES driver, oops.
   From Dave Jones.

2) Tell GCC that prom_printf() is printf-like and fix the few
   resultiing warnings.  From Akinobu Mita.

3) Niagara-2 memcpy doesn't provide it's return value correctly
   in some circumstances.

Please pull, thanks a lot.

The following changes since commit 7fe0b14b725d6d09a1d9e1409bd465cb88b587f9:

  Merge tag 'spi-3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc (2012-10-02 17:26:42 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 5da444aae54f64575a60f1d596ed7706e3089fb0:

  sparc: fix format string argument for prom_printf() (2012-10-02 23:20:34 -0400)

----------------------------------------------------------------
Akinobu Mita (1):
      sparc: fix format string argument for prom_printf()

Dave Jones (1):
      crypto: Build SPARC DES algorithms on SPARC only.

David S. Miller (2):
      sparc64: Fix return value of Niagara-2 memcpy.
      Merge git://git.kernel.org/.../torvalds/linux

 arch/sparc/include/asm/oplib_32.h |  2 +-
 arch/sparc/include/asm/oplib_64.h |  2 +-
 arch/sparc/kernel/hvapi.c         |  2 +-
 arch/sparc/kernel/prom_64.c       |  2 +-
 arch/sparc/kernel/traps_64.c      |  2 +-
 arch/sparc/lib/NG2memcpy.S        | 46 +++++++++++++++++++++++-----------------------
 arch/sparc/mm/init_64.c           |  7 ++++---
 arch/sparc/mm/iommu.c             |  4 ++--
 crypto/Kconfig                    |  1 +
 9 files changed, 35 insertions(+), 33 deletions(-)
