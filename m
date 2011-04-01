Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1DAGeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:34:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54504
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230Ab1DAGeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:34:07 -0400
Date: Thu, 31 Mar 2011 23:33:30 -0700 (PDT)
Message-Id: <20110331.233330.226762625.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Fix section mismatch errors on sparc64.  These were all legitimate
   and were resulting in freed memory being referenced after boot.

2) Hook up sys_syncfs

3) apbuart LEON driver fixes from Daniel Hellstrom.

Please pull, thanks a lot!

The following changes since commit ecb78ab6f30106ab72a575a25b1cdfd1633b7ca2:

  Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6 (2011-03-30 12:22:15 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Daniel Hellstrom (2):
      sparc32, leon: APBUART driver must use archdata to get IRQ number
      sparc32,leon: Fixed APBUART frequency detection

David S. Miller (3):
      sparc: Hook up syncfs system call.
      sparc64: Fix section mis-match errors.
      apbuart: Depend upon sparc.

Tkhai Kirill (1):
      sparc32: Pass task_struct to schedule_tail() in ret_from_fork

 arch/sparc/include/asm/unistd.h |    3 ++-
 arch/sparc/kernel/auxio_64.c    |    2 +-
 arch/sparc/kernel/central.c     |    4 ++--
 arch/sparc/kernel/ds.c          |    2 +-
 arch/sparc/kernel/entry.S       |    2 +-
 arch/sparc/kernel/mdesc.c       |    2 +-
 arch/sparc/kernel/pci_fire.c    |    2 +-
 arch/sparc/kernel/pci_psycho.c  |    2 +-
 arch/sparc/kernel/pci_sabre.c   |    2 +-
 arch/sparc/kernel/pci_schizo.c  |    2 +-
 arch/sparc/kernel/pci_sun4v.c   |    2 +-
 arch/sparc/kernel/power.c       |    2 +-
 arch/sparc/kernel/systbls_32.S  |    2 +-
 arch/sparc/kernel/systbls_64.S  |    2 ++
 arch/sparc/kernel/time_64.c     |    6 +++---
 drivers/tty/serial/Kconfig      |    2 +-
 drivers/tty/serial/apbuart.c    |   34 +++++++++++-----------------------
 17 files changed, 32 insertions(+), 41 deletions(-)
