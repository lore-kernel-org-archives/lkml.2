Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1DAFhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 01:37:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:40492 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1DAFhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 01:37:23 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 16:36:40 +1100
Message-ID: <1301636200.2549.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Some more powerpc bits for you.

One is actually a change from Anton to the generic kexec to make a
function weak so powerpc can override it.

It has been around for ever, there were initial objections I think
mostly due to a misunderstanding of the problem.

Since then, it's been a deafening silence to our responses/expanations
and no answers from Eric so I think it should go in as the powerpc
counterpart that implements our version of that weak function is already
(and has been for a while as d72e063bb32c06c6c1cec14f6857b7c37ba62d7a)
and it fixes a real nasty bug.

The rest is a series of fixes to our CPU hotplug code that I've been
sitting on for a little while (by myself) and was originally thinking
about putting in for the next release.

I eventually changed my mind, there is no point in sitting on them any
longer since they fix some real issues on some machines (such as G5's
crashing on re-plug) and brings us in line with what other archs do for
setting up and re-initializing the idle threads.

Cheers,
Ben.

The following changes since commit ecb78ab6f30106ab72a575a25b1cdfd1633b7ca2:

  Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6 (2011-03-30 12:22:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Blanchard (1):
      kdump: Allow shrinking of kdump region to be overridden

Benjamin Herrenschmidt (18):
      powerpc: Make decrementer interrupt robust against offlined CPUs
      powerpc/smp: soft-replugged CPUs must go back to start_secondary
      powerpc/smp: Fix generic_mach_cpu_die()
      powerpc/smp: Remove unused generic_cpu_enable()
      powerpc/smp: Remove unused smp_ops->cpu_enable()
      powerpc/pmac/smp: Fix 32-bit PowerMac cpu_die
      powerpc/pmac/smp: Rename fixup_irqs() to migrate_irqs() and use it on ppc32
      powerpc/pmac/smp: Fixup smp_core99_cpu_disable() and use it on 64-bit
      powerpc/pmac/smp: Consolidate 32-bit and 64-bit PowerMac cpu_die in one file
      powerpc/pmac/smp: Remove HMT changes for PowerMac offline code
      powerpc/pmac/smp: Properly NAP offlined CPU on G5
      powerpc/pmac: Rename cpu_state in therm_pm72 to avoid collision
      powerpc/smp: Add a smp_ops->bringup_up() done callback
      powerpc/pmac/smp: Fix CPU hotplug crashes on some machines
      powerpc/smp: Don't expose per-cpu "cpu_state" array
      powerpc/smp: Create idle threads on demand and properly reset them
      powerpc/smp: Increase vdso_data->processorCount, not just decrease it
      powerpc/pmac/smp: Remove no-longer needed preempt workaround

 arch/powerpc/include/asm/machdep.h              |    3 +-
 arch/powerpc/include/asm/smp.h                  |    5 +-
 arch/powerpc/kernel/head_32.S                   |    9 ++
 arch/powerpc/kernel/head_64.S                   |    7 +
 arch/powerpc/kernel/idle_power4.S               |   21 ---
 arch/powerpc/kernel/irq.c                       |    3 +-
 arch/powerpc/kernel/smp.c                       |  153 ++++++++++++++--------
 arch/powerpc/kernel/time.c                      |   15 ++-
 arch/powerpc/platforms/powermac/pmac.h          |    1 -
 arch/powerpc/platforms/powermac/setup.c         |   56 --------
 arch/powerpc/platforms/powermac/smp.c           |  154 ++++++++++++++++-------
 arch/powerpc/platforms/pseries/offline_states.h |    2 -
 drivers/macintosh/therm_pm72.c                  |   60 +++++-----
 include/linux/kexec.h                           |    1 +
 kernel/kexec.c                                  |    5 +-
 15 files changed, 272 insertions(+), 223 deletions(-)


