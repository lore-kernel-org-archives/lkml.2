Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2IEGM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:12:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:56817 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2IEGM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:12:57 -0400
Message-ID: <1346825568.2257.55.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 05 Sep 2012 16:12:48 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few fixes for 3.6 that were piling up while I was away or
busy (I was mostly MIA a week or two before San Diego). Some fixes from
Anton fixing up issues with our relatively new DSCR control feature,
and a few other fixes that are either regressions or bugs nasty enough
to warrant not waiting.

Cheers,
Ben.

The following changes since commit 5b716ac728bcc01b1f2a7ed6e437196602237c27:

  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6 (2012-09-02 11:30:10 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git 

for you to fetch changes up to 636802ef96eebe279b22ad9f9dacfe29291e45c7:

  powerpc: Don't use __put_user() in patch_instruction (2012-09-05 16:05:23 +1000)

----------------------------------------------------------------
Anton Blanchard (4):
      powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
      powerpc: Keep thread.dscr and thread.dscr_inherit in sync
      powerpc: Fix DSCR inheritance in copy_thread()
      powerpc: Restore correct DSCR in context switch

Benjamin Herrenschmidt (1):
      powerpc: Don't use __put_user() in patch_instruction

Jesse Larrew (1):
      powerpc/vphn: Fix arch_update_cpu_topology() return value

Paul Mackerras (3):
      powerpc: Give hypervisor decrementer interrupts their own handler
      powerpc/powernv: Always go into nap mode when CPU is offline
      powerpc: Make sure IPI handlers see data written by IPI senders

 arch/powerpc/include/asm/processor.h |    1 +
 arch/powerpc/kernel/asm-offsets.c    |    1 +
 arch/powerpc/kernel/dbell.c          |    2 ++
 arch/powerpc/kernel/entry_64.S       |   23 +++++++++++++++++------
 arch/powerpc/kernel/exceptions-64s.S |    3 ++-
 arch/powerpc/kernel/idle_power7.S    |    2 ++
 arch/powerpc/kernel/process.c        |   12 ++----------
 arch/powerpc/kernel/smp.c            |   11 +++++++++--
 arch/powerpc/kernel/sysfs.c          |   10 ++++++++++
 arch/powerpc/kernel/time.c           |    9 +++++++++
 arch/powerpc/kernel/traps.c          |    3 ++-
 arch/powerpc/lib/code-patching.c     |    2 +-
 arch/powerpc/mm/numa.c               |    7 ++++---
 arch/powerpc/platforms/powernv/smp.c |   10 +---------
 arch/powerpc/sysdev/xics/icp-hv.c    |    6 +++++-
 15 files changed, 68 insertions(+), 34 deletions(-)


