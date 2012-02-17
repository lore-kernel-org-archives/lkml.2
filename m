Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2BQWhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:37:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:36609 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab2BQWhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:37:03 -0500
Message-ID: <1329518214.3980.7.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 18 Feb 2012 09:36:54 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more fixes for powerpc. Some are regressions, the rest is
simple/obvious/nasty enough that I deemed it good to go now.

Here's also step one of deprecating legacy iSeries support: we are
removing it from the main defconfig.

Nobody seems to be using it anymore and the code is nasty to maintain,
(involves horrible hacks in various low level areas of the kernel) so we
plan to actually rip it out at some point. For now let's just avoid
building it by default. Stephen will proceed to do the actual removal
later (probably 3.4 or 3.5).

Cheers,
Ben.

The following changes since commit 778a785f02ad846446e91dab49331bd7d853c514:

  powerpc/pseries/eeh: Fix crash when error happens during device probe (2012-02-14 15:01:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 9a45a9407c69d068500923480884661e2b9cc421:

  powerpc/perf: power_pmu_start restores incorrect values, breaking frequency events (2012-02-16 16:24:35 +1100)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc/perf: power_pmu_start restores incorrect values, breaking frequency events

Benjamin Herrenschmidt (2):
      powerpc/fsl/pci: Fix PCIe fixup regression
      powerpc: Disable interrupts early in Program Check

Ira Snyder (1):
      powerpc: Fix kernel log of oops/panic instruction dump

Stephen Rothwell (1):
      powerpc: Remove legacy iSeries from ppc64_defconfig

majianpeng (1):
      powerpc/adb: Use set_current_state()

 arch/powerpc/configs/ppc64_defconfig |    5 ---
 arch/powerpc/kernel/exceptions-64s.S |    2 +-
 arch/powerpc/kernel/perf_event.c     |    8 +++++-
 arch/powerpc/kernel/process.c        |    6 ++--
 arch/powerpc/sysdev/fsl_pci.c        |   48 ++++++++++++++++++++-------------
 drivers/macintosh/adb.c              |    4 +-
 6 files changed, 42 insertions(+), 31 deletions(-)


