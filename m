Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1CUQp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:45:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38617 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab1CUQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:45:58 -0400
Subject: [GIT PULL] parisc updates for the 2.6.38 merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 11:45:54 -0500
Message-ID: <1300725954.10634.28.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two major changes in this: one is our full conversion to the
generic IRQ handlers thanks to tglx and the other is switching us to use
tmpalias flushing (a change which means that our coherency no-longer
relies on the mechanics of page tables being present).  We still have
quite a lot of work to do, but the change to tmpalias flushing is at
last allowing us to track down some of the very infrequent coherency
issues on the platform.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#for-linus

The short changelog is:

James Bottomley (3):
      [PARISC] fix vmap flush/invalidate
      eliminate special FLUSH flag from page table
      parisc: flush pages through tmpalias space

Thomas Gleixner (2):
      [PARISC] Convert to new irq_chip functions
      [PARISC] fix per-cpu flag problem in the cpu affinity checkers

And the diffstat

 arch/parisc/Kconfig                  |    1 +
 arch/parisc/include/asm/cacheflush.h |   31 +++--
 arch/parisc/include/asm/irq.h        |   13 +--
 arch/parisc/include/asm/pgtable.h    |   14 +--
 arch/parisc/kernel/cache.c           |  109 +++-------------
 arch/parisc/kernel/entry.S           |  217 +++++++++++++++++-------------
 arch/parisc/kernel/irq.c             |   64 +++++----
 arch/parisc/kernel/pacache.S         |  245 +++++++++++++++-------------------
 drivers/parisc/dino.c                |   22 ++--
 drivers/parisc/eisa.c                |   12 +-
 drivers/parisc/gsc.c                 |   22 ++--
 drivers/parisc/iosapic.c             |   40 +++---
 drivers/parisc/superio.c             |   12 +-
 13 files changed, 375 insertions(+), 427 deletions(-)

James


